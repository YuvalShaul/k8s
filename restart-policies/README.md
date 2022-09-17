# Restart Policies

In this lab we will demonstrate using probes to monitor containers health.

- [Always pod](#Always-pod)
- [OnFailure pod](#OnFailure-pod)

## Always pod

- Look at **always-pod.yaml** from this lab.  
This pod has a Always restart policy.
- Run this pod:  
**kubectl apply -f always-pod.yaml**
- The pod will restart in a CrashLoopBackOff manner (as explained in class)

## OnFailure pod

- Look at the **onfailure-pod.yaml** pod from this lab:  
It is just the restartPolicy that has changed to OnFailure.
- Run it the same way you did with the always-pod
- Notice that the pod has come to the **completed** state, and not restarted.
- Delete the onfailure pod.
- Change the onfailure-pod.yaml to fail, by changing the command:  
**command: ['sh', '-c', 'sleep 10; bla bla']**  
- Run the pods again.  
Now it will be restarted.

It should not be difficult to try the **Never** restart policy.