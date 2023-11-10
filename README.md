# Keycloak and Kubernetes Integration Guide

This comprehensive guide walks you through the process of integrating Keycloak with Kubernetes for seamless authentication and RBAC-based access control.

## Part 1: Keycloak Setup

### Create and Assign a Role in Keycloak:

1. **Log in to Keycloak:**
   Access the Keycloak admin interface and log in.

2. **Create a Role:**
   - Navigate to Realm Settings -> Roles.
   - Add a new role, e.g., `cluster-admin`.

   ```yaml
   kind: Role
   metadata:
     name: cluster-admin
   ```

3. **Assign the Role to Users:**
   - Navigate to Users -> select the user -> Realm Roles.
   - Assign the new role (`cluster-admin`) to the user.

   ```yaml
   apiVersion: rbac.authorization.k8s.io/v1
   kind: RoleBinding
   metadata:
     name: cluster-admin-binding
   subjects:
   - kind: User
     name: <username>
     apiGroup: rbac.authorization.k8s.io
   roleRef:
     kind: Role
     name: cluster-admin
     apiGroup: rbac.authorization.k8s.io
   ```

### Link a Group to a Role in Keycloak:

1. **Create Groups:**
   - Navigate to Users -> Groups.
   - Add groups, e.g., `argocd-admin`.

   ```yaml
   apiVersion: rbac.authorization.k8s.io/v1
   kind: ClusterRoleBinding
   metadata:
     name: argocd-admin-binding
   subjects:
   - kind: Group
     name: argocd-admin
     apiGroup: rbac.authorization.k8s.io
   roleRef:
     kind: ClusterRole
     name: cluster-admin
     apiGroup: rbac.authorization.k8s.io
   ```

2. **Assign Users to Groups:**
   - In the Members section, add relevant users to the group.

   ```yaml
   apiVersion: rbac.authorization.k8s.io/v1
   kind: RoleBinding
   metadata:
     name: argocd-user-binding
     namespace: argocd
   subjects:
   - kind: User
     name: <username>
     apiGroup: rbac.authorization.k8s.io
   roleRef:
     kind: ClusterRole
     name: argocd-user
     apiGroup: rbac.authorization.k8s.io
   ```

3. **Assign Roles to Groups:**
   - Navigate to Users -> Groups -> [group-name] -> Roles Mapping.
   - Add the roles you want to assign to the group. Add `cluster-admin` to reflect the role defined in Keycloak for Kubernetes permissions.

## Part 2: Reflection in Kubernetes

### Configure Keycloak Connector in Kubernetes:

1. **Set up Keycloak Connector:**
   - Configure the Keycloak Connector for Kubernetes to enable the Kubernetes cluster to authenticate against Keycloak.

   ```yaml
   spec:
     kubeAPIServer:
       oidcClientID: kubernetes
       oidcGroupsClaim: groups
       oidcGroupsPrefix: 'keycloak:'
       oidcIssuerURL: https://<keycloakserverurl>/auth/realms/master
       oidcUsernameClaim: email
   ```

2. **Ensure Attribute Propagation:**
   - In the Keycloak Connector configuration, ensure that attributes, such as groups or roles, are correctly propagated to the Kubernetes authentication token.

3. **Configure RBAC in Kubernetes:**
   - Utilize Kubernetes RBAC mechanisms to associate roles and permissions defined in Keycloak with Kubernetes resources.

   ```yaml
   apiVersion: rbac.authorization.k8s.io/v1
   kind: ClusterRoleBinding
   metadata:
     name: keycloak-admin-binding
   subjects:
   - kind: Group
     name: keycloak:admin
     apiGroup: rbac.authorization.k8s.io
   roleRef:
     kind: ClusterRole
     name: cluster-admin
     apiGroup: rbac.authorization.k8s.io
   ```

Follow these steps and incorporate the provided YAML examples to seamlessly integrate Keycloak with Kubernetes, allowing for secure and fine-grained access control within your Kubernetes cluster.
