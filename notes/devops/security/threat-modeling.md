# Threat Modeling

Threat modeling is a systematic approach to identifying, assessing, and mitigating security threats in systems or applications.

## Steps

1. **Define system scope:** Map architecture and data flows.
2. **Identify assets:** List sensitive or valuable data/components.
3. **Identify threats:** Use frameworks (e.g., STRIDE) to find risks.
4. **Prioritize risks:** Rank threats by impact/likelihood.
5. **Plan mitigations:** Define controls to reduce risks.

## Common Frameworks

- **STRIDE:** Spoofing, Tampering, Repudiation, Information Disclosure, Denial of Service, Elevation of Privilege
- **DREAD:** Damage, Reproducibility, Exploitability, Affected Users, Discoverability
- **LINDDUN:** Focused on privacy threats

### STRIDE Terms

- **Spoofing**: Pretending to be another user, device, or process (e.g., fake logins, identity theft)
- **Tampering**: Unauthorized modification of data, code, or configurations (e.g., altering files, database data manipulation)
- **Repudiation**: Performing actions that cannot be traced back to the user (e.g., denying sending a message or executing a transaction)
- **Information Disclosure**: Exposing sensitive data to unauthorized users (e.g., data leaks, unencrypted transmissions)
- **Denial of Service (DoS)**: Disrupting system availability or resource access (e.g., flooding servers, forcing crashes)
- **Elevation of Privilege**: Gaining higher rights/permissions than intended (e.g., a normal user executing admin actions)

### DREAD Terms

- **Damage**: Potential severity of a successful attack
- **Reproducibility**: How easily the attack can be repeated
- **Exploitability**: Effort or resources needed to launch the attack
- **Affected Users**: Scope or number of impacted users
- **Discoverability**: How easy it is to uncover the vulnerability

### LINDDUN Focus Areas (For Privacy)

- Linkability, Identifiability, Non-repudiation, Detectability, Disclosure of information, Unawareness, Non-compliance (focuses on privacy/privacy-related threats)

### Examples

**STRIDE Example:**

- Asset: User accounts
- Threat: Spoofing – An attacker impersonates a user via weak login logic
- Mitigation: Add multi-factor authentication

**DREAD Example:**

- Threat: SQL Injection
- Analysis:
  - Damage: High (data breach)
  - Reproducibility: Easy
  - Exploitability: Simple tools available
  - Affected Users: Potentially all
  - Discoverability: Query parameters are obvious
- Mitigation: Use prepared statements for all queries

**LINDDUN Example:**

- Asset: User profile data
- Threat: Linkability – Combining usage logs and profile data reveals identities
- Mitigation: Anonymize logs and separate PII from usage data
