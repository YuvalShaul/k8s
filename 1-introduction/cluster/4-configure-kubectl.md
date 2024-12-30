# 4 - kubectl on you Host Lab

In this lab you will install and configure **kubectl** on your host machine.

## kubectl installation

- Install **kubectl** on your host machine:  
Use [this](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/#install-using-native-package-management) link.  
There is a Debian based tab (for Ubuntu and other Debian based dstributions), and a RedHat tab (for Centos and other RedHat distributions). 
- After the installation, you should verify the existence of the $HOME/.kube directory.  
If it does not exist - create it:  
**mkdir ~/.kube**
- Use the scp (ssh copy) command to copy the config file from the control node:  
**cd .kube**  
**scp osboxes@192.168.122.10:.kube/config .**  
This will copy the **config** [configuration file](https://kubernetes.io/docs/concepts/configuration/organize-cluster-access-kubeconfig/) into your host machine.
- Use the **kubectl cluster-info** command to see if you get the details of the cluster correctly.
- Try **kubectl get nodes** command.
