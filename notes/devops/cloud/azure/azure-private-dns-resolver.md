# Azure Private DNS Resolver

## Automatic Private Endpoint Resolution from Public Endpoints

Azure services can automatically resolve public endpoints to private IPs when:

1. **A private endpoint** is configured for the service (e.g., Azure SQL Database)
2. **A private DNS zone** is linked to the virtual network (e.g., `privatelink.database.windows.net`)
3. **DNS zone group** is configured on the private endpoint

**Use Case Example:**
- Container App or Web App connects using the **public endpoint DNS name** (e.g., `myserver.database.windows.net`)
- Azure DNS automatically resolves it to the **private IP** in the private DNS zone
- Connection happens entirely over the private network without exposing the service to the internet

This works transparently - no code changes needed. The application uses the same public endpoint URL but Azure's DNS resolution handles the routing to the private IP.
