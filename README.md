# Keycloak and Kubernetes RBAC Integration

This guide provides an overview of how to define roles in Keycloak and how to associate these roles with groups to manage permissions within a Kubernetes cluster.

## Create and Assign a Role in Keycloak:

1. **Log in to Keycloak:**
   Access the Keycloak admin interface and log in.

2. **Create a Role:**
   - Navigate to Realm Settings -> Roles.
   - Add a new role and give it a name, for example, `cluster-admin`.

3. **Assign the Role to Users:**
   - Navigate to Users -> select the user -> Realm Roles.
   - Assign the new role (`cluster-admin`) to the user.

## Link a Group to a Role in Keycloak:

1. **Create Groups:**
   - Navigate to Users -> Groups.
   - Add groups, for example, `argocd-admin`.

2. **Assign Users to Groups:**
   - In the `Members` section, add relevant users to the group.

3. **Assign Roles to Groups:**
   - Navigate to Users -> Groups -> [group-name] -> Roles Mapping.
   - Add the roles you want to assign to the group. Add `cluster-admin` to reflect the role defined in Keycloak for Kubernetes permissions.

## Reflection in Kubernetes:

1. **Configure Keycloak Connector in Kubernetes:**
   - Set up the Keycloak Connector for Kubernetes to allow the Kubernetes cluster to authenticate against Keycloak.

2. **Ensure Attribute Propagation:**
   - In the Keycloak Connector configuration, ensure that attributes, such as groups or roles, are correctly propagated to the Kubernetes authentication token.

3. **Configure RBAC in Kubernetes:**
   - Use Kubernetes RBAC mechanisms to associate roles and permissions defined in Keycloak with Kubernetes resources.
