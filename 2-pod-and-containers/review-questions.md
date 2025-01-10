## Pods and containers - Review questions

1. What kind of storage can containers-in-the-same-pod share?
2. So what is really shared between containers in the same pod?
3. If a single pod fails, will kubernetes run it again?
4. What about pod health probes? Won't they run my pod again?
5. What should be a good motivation to include multiple containers in the same pod?



### Answers

1. The basic thing to remember here is that **each container has its own private file-system that is not shared tieh the other pod.**  
Pods can create volumes, and containers can create mount points for this volumes:
- EmptyDir volumes: These are temporary volumes that exist for the pod's lifetime.  
They're created when the pod is assigned to a node and deleted when the pod is removed.  
Useful for:
  - Sharing temporary data between containers
  - Checkpoint storage in long computations
  - Holding data for recovery in case of crashes
- Shared volumes: Multiple containers can mount the same persistent volume or volume claim, allowing them to read and write to the same storage space.  
This works with various volume types like:
  - HostPath
  - PersistentVolumes
  - ConfigMaps
  - Secrets

2. By default, containers in the same pod share:
- Network namespace:
  - Same IP address
  - Same port space (so they must use different ports)
  - Can communicate via localhost
  - Share the same network interfaces
- IPC (Inter-Process Communication) namespace:
  - Can communicate via SystemV IPC
  - Can communicate via POSIX message queues
  - Shared memory segments are accessible between containers
- Hostname and DNS config:
  - Share the same hostname (pod name)
  - Same DNS settings
  - Same /etc/hosts and /etc/resolv.conf
Notably, by default containers do NOT share:
- Filesystem (each has its own)
- Process namespace (can't see each other's processes)
- User namespace (user names and groups)
- UTS namespace (except hostname)  
Storage must be explicitly shared using volumes if needed.

3. No - a pod by itself won't be restarted by Kubernetes if it fails.  
You need a controller (like Deployment, StatefulSet, DaemonSet) to manage the pod lifecycle and handle pod failures.  
These controllers will:
- Monitor pod health
- Restart failed pods
- Maintain the desired number of replicas
For example:
- A Deployment will create a new pod if one fails
- A StatefulSet will recreate a failed pod with the same name and persistent storage
- A DaemonSet will ensure a new pod runs on the node where one failed
If you run a "naked" pod (created directly without a controller), when it fails:
- It will stay in Failed/Completed state
- No new pod will be created
- You would need to manually recreate it
This is why it's recommended to always use controllers rather than creating pods directly.


4. No - even with health probes configured, a standalone pod won't be automatically recreated when it fails.  
Health probes (liveness, readiness, startup) only tell Kubernetes about the state of your pod and its containers.   They can:
- Kill and restart containers within the pod (liveness probe)
- Remove the pod from service endpoints (readiness probe)
- Give your app time to startup (startup probe)
But they don't provide automatic recreation of the entire pod.  


5. he main good reasons to include multiple containers in the same pod are:
- Sidecar pattern - where you have an auxiliary container that helps the main application:
  - Log collectors/forwarders
  - Monitoring agents
  - Configuration/secret updaters
  - Service mesh proxies (like Istio)
- Init containers that must run to completion before the main container:
  - Database schema setup
  - Configuration preparation
  - Waiting for dependencies to be ready
  - File/data preparation
- Tightly coupled containers that need:
  - To share localhost network (direct communication)
  - To share the same lifecycle (start/stop together)
  - To coordinate file system access
  - To share process namespace (can see each other's processes)

The key principle is: put containers in the same pod only if they need to be tightly coupled and co-located.  
If containers can run independently, they should be in separate pods.
Bad reasons would be:
- Trying to save resources (use resource limits instead)
- Administrative convenience
- Containers that could run independently
- Services that don't need direct localhost communication