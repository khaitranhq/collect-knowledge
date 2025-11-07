# Development Security Scanning Tools

## Overview

Security scanning tools integrated into the development process enable **shift-left security** by identifying vulnerabilities early in the SDLC. Modern DevSecOps practices combine multiple scanning approaches to achieve comprehensive coverage from code commit to production.

## Core Tool Categories

### 1. SAST (Static Application Security Testing)

**Purpose**: Analyze source code/bytecode for security flaws without executing the application (white-box testing).

**Leading Tools (2025)**:

- **Snyk Code** - Developer-friendly with IDE plugins (VS Code, IntelliJ, Eclipse), real-time feedback, auto-fix suggestions
- **Semgrep** - Lightweight, rule-based scanning with fast IDE integration and low false positives
- **SonarQube/SonarCloud** - Comprehensive code quality + security analysis with extensive language support
- **Checkmarx** - Enterprise-grade with AI-powered context-aware scanning (25+ languages)
- **Mend SAST** (formerly WhiteSource) - Real-time developer feedback with incremental scanning
- **Veracode Static Analysis** - Cloud-native with pipeline integration and compliance reporting
- **Aikido Security** - Unified platform bundling SAST with SCA, IaC, and secrets scanning

**Key Features**:

- ✅ IDE integration for real-time feedback
- ✅ CI/CD pipeline automation
- ✅ Incremental scanning (analyze only changed code)
- ✅ Detects: injection flaws, broken access controls, crypto failures, misconfigurations
- ⚠️ Can produce false positives; requires tuning

---

### 2. DAST (Dynamic Application Security Testing)

**Purpose**: Test running applications from an attacker's perspective by simulating real-world attacks (black-box testing).

**Leading Tools (2025)**:

- **Invicti** (formerly Netsparker/Acunetix) - DAST+IAST hybrid with proof-based scanning
- **Escape DAST** - Specialized for modern SPAs, REST & GraphQL APIs
- **StackHawk** - Developer-focused with CI/CD integration
- **OWASP ZAP** - Open-source web app pentesting tool
- **Veracode Dynamic Testing** - Cloud-native for web apps and APIs
- **Bright Security** (formerly NeuraLegion) - Enterprise-grade automated crawler
- **Rapid7 InsightAppSec** - Automated vulnerability validation

**Key Features**:

- ✅ Identifies runtime vulnerabilities (SQL injection, XSS, exposed DBs)
- ✅ Automated crawling of HTML5, JavaScript, SPAs
- ✅ Proof-based validation reduces false positives
- ✅ Complements SAST by finding deployment/config issues
- ⚠️ Requires running application environment

---

### 3. SCA (Software Composition Analysis)

**Purpose**: Scan open-source dependencies and third-party libraries for known vulnerabilities and license risks.

**Leading Tools (2025)**:

- **Mend** (formerly WhiteSource) - Best for automated remediation and SBOM generation
- **Snyk Open Source** - Excellent developer experience with dependency upgrade PRs
- **Sonatype Lifecycle** - Enterprise policy management and repository firewall
- **Checkmarx SCA** - Comprehensive coverage with container integration
- **GitHub Dependabot** - Native GitHub integration with automated PRs
- **JFrog Xray** - Deep artifact analysis for JFrog Artifactory users

**Key Features**:

- ✅ Continuous monitoring of dependencies across branches
- ✅ SBOM (Software Bill of Materials) generation
- ✅ License compliance checking
- ✅ Automated remediation with pull requests
- ✅ Can reduce remediation time by up to 80%

---

### 4. IAST (Interactive Application Security Testing)

**Purpose**: Instruments applications during runtime (testing/QA) to combine SAST and DAST benefits with code-level insight.

**Leading Tools (2025)**:

- **Contrast Security IAST** - Real-time agent-based analysis during functional testing
- **Invicti IAST** - Combined DAST-IAST engine
- **Checkmarx IAST** - Integrated with broader Checkmarx suite

**Key Features**:

- ✅ High-confidence findings with detailed code traces
- ✅ Low false positive rate
- ✅ Real-time vulnerability detection during testing
- ⚠️ Requires application instrumentation

---

### 5. Additional Scanning Tools

#### **Secrets Detection**

- **GitGuardian** - Monitors commits for exposed API keys, credentials, tokens
- **TruffleHog** - Open-source secret scanning
- **Spectral** - Real-time secrets detection

#### **Container Security**

- **Trivy** - Comprehensive container, IaC, and file system scanning
- **Grype** - Vulnerability scanner for container images
- **Anchore** - Automated container scanning with policy enforcement
- **Aqua Security** - Enterprise container security platform

#### **IaC (Infrastructure as Code) Scanning**

- **Checkov** - Policy-as-code for Terraform, CloudFormation, Kubernetes
- **Terrascan** - Detect misconfigurations before deployment
- **KICS** - Open-source IaC scanner (Terraform, Kubernetes, Docker)

---

## Integration Best Practices

### Shift-Left Strategy

```
IDE → Pre-commit → CI/CD → Staging → Production
 ↓         ↓          ↓         ↓         ↓
SAST    Secrets    SCA+SAST   DAST     RASP*
        Scanning   +IaC       +IAST    (Runtime)
```

\*RASP (Runtime Application Self-Protection) embeds in production to block attacks

### Recommended Tool Combinations

1. **Startup/Small Teams**: Snyk (SAST+SCA) + OWASP ZAP (DAST) + GitGuardian
2. **Mid-Size Orgs**: Aikido (unified SAST/SCA/IaC/secrets) + Trivy (containers)
3. **Enterprise**: Checkmarx (SAST+IAST) + Mend (SCA) + Invicti (DAST) + Aqua (containers)

### CI/CD Integration Checklist

- [ ] Automated scanning on every pull request
- [ ] Fast feedback loops (< 5 min for incremental scans)
- [ ] Policy gates to block high/critical vulnerabilities
- [ ] Centralized dashboard for vulnerability management
- [ ] Developer-friendly alerts (in PRs, IDE, Slack)
- [ ] Automated remediation (e.g., dependency update PRs)

---

## Tool Selection Criteria

### Must-Have Features (2025)

1. **IDE Integration** - Real-time feedback without leaving code editor
2. **Low False Positives** - AI/ML-powered filtering and proof-based validation
3. **CI/CD Native** - GitHub Actions, GitLab CI, Jenkins, Bitbucket Pipelines support
4. **Developer Experience** - Contextual remediation guidance, not just CVE lists
5. **Incremental Scanning** - Analyze only changed code for speed
6. **SBOM Generation** - Automated software bill of materials for compliance

### Platform Consolidation Trend

Modern tools are converging into **unified DevSecOps platforms** that combine:

- SAST + DAST + SCA + IAST + Secrets + Container + IaC scanning
- Single dashboard for all vulnerabilities
- AI-powered prioritization
- Automated remediation workflows

**Examples**: Aikido, Invicti, Checkmarx One, Snyk (unified platform)

---

## Compliance & Standards

### Industry Requirements

All major frameworks require automated security testing:

- **OWASP Top 10 2024** - Injection, broken access control, crypto failures
- **NIST SSDF** - Secure software development framework
- **PCI-DSS v4.0** - Payment card industry security standards
- **SOC 2** - Security and compliance controls
- **ISO 27001** - Information security management

### Scanning Coverage Map

| Vulnerability Type         | SAST | DAST | SCA | IAST |
| -------------------------- | :--: | :--: | :-: | :--: |
| SQL Injection              |  ✅  |  ✅  | ❌  |  ✅  |
| XSS                        |  ✅  |  ✅  | ❌  |  ✅  |
| Broken Auth                |  ✅  |  ✅  | ❌  |  ✅  |
| Known CVEs in Dependencies |  ❌  |  ❌  | ✅  |  ❌  |
| License Violations         |  ❌  |  ❌  | ✅  |  ❌  |
| Config Errors              |  ⚠️  |  ✅  | ❌  |  ✅  |
| API Security               |  ⚠️  |  ✅  | ❌  |  ✅  |
| Race Conditions            |  ❌  |  ❌  | ❌  |  ✅  |

---

## Quick Reference

### Open Source Options

- **SAST**: Semgrep, Bandit (Python), Brakeman (Ruby)
- **DAST**: OWASP ZAP, Nikto
- **SCA**: OWASP Dependency-Check, npm audit, pip-audit
- **Secrets**: TruffleHog, Gitleaks
- **Containers**: Trivy, Grype, Clair
- **IaC**: Checkov, KICS, tfsec

### Commercial Leaders by Category

- **Best All-in-One**: Aikido, Snyk, Checkmarx One
- **Best SAST**: Checkmarx, Veracode, Mend
- **Best DAST**: Invicti, Escape, Bright Security
- **Best SCA**: Mend, Sonatype, Snyk
- **Best Developer Experience**: Snyk, Aikido, Semgrep

---

## Implementation Roadmap

### Phase 1: Foundation (Weeks 1-2)

1. Enable **secrets scanning** (GitGuardian/TruffleHog) on all repos
2. Integrate **SCA** (Snyk/Dependabot) for dependency monitoring
3. Add **SAST** to CI/CD pipeline with non-blocking mode

### Phase 2: Expansion (Weeks 3-4)

4. Deploy **IDE plugins** for real-time SAST feedback
5. Enable **container scanning** (Trivy) in build pipeline
6. Add **IaC scanning** (Checkov) for infrastructure repos

### Phase 3: Advanced (Weeks 5-8)

7. Integrate **DAST** for staging environment testing
8. Implement policy gates (block on critical/high CVEs)
9. Set up centralized vulnerability dashboard
10. Enable automated remediation PRs

---

## Key Metrics to Track

- **Mean Time to Remediate (MTTR)** - Target: < 30 days for high severity
- **Vulnerability Escape Rate** - % of vulns found in production vs. dev
- **False Positive Rate** - Aim for < 10% after tuning
- **Scan Coverage** - % of repos/containers scanned automatically
- **Developer Adoption** - % of devs using IDE security plugins
- **Pipeline Impact** - Keep scan time < 10% of total build time

---

## References & Resources

- [OWASP DevSecOps Guideline](https://owasp.org/www-project-devsecops-guideline/)
- [NIST Secure Software Development Framework](https://csrc.nist.gov/Projects/ssdf)
- [Gartner AST Reviews 2025](https://www.gartner.com/reviews/market/application-security-testing)
- [OWASP Top 10 2024](https://owasp.org/www-project-top-ten/)

---

**Last Updated**: October 2025  
**Review Cycle**: Quarterly (tools and vendors evolve rapidly)

