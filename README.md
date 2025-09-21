<div align="center">



*VirusX: Beyond VirusTotal – Advanced Threat Intelligence Platform*

[![Ruby on Rails](https://img.shields.io/badge/Ruby_on_Rails-Latest-CC0000?style=for-the-badge&logo=rubyonrails)](https://rubyonrails.org/)
[![Reverse Lookup](https://img.shields.io/badge/Reverse-Lookup-555555?style=for-the-badge)](#)
[![ViewDNS](https://img.shields.io/badge/ViewDNS-Enabled-4FC08D?style=for-the-badge)](#)
[![WaybackURL](https://img.shields.io/badge/Wayback-URL-2C3E50?style=for-the-badge)](#)
[![HTTPx](https://img.shields.io/badge/HTTPx-Supported-000000?style=for-the-badge)](#)
[![VirusData](https://img.shields.io/badge/Virus-Data_APIs-008000?style=for-the-badge)](#)


<img width="1392" height="830" alt="image" src="https://github.com/user-attachments/assets/ac7b481f-ceb0-4c5d-b854-feff66514f74" />


**Because malware doesn’t sleep – neither should your analysis.**

[🚀 Live Demo](#) • [🔧 Installation](#installation)

</div>

---

## ✨ Overview

**VirusX** is a Ruby on Rails-powered threat intelligence platform inspired by VirusTotal, but enhanced with additional features.  
It allows scanning of **URLs, files, domains, and IP addresses**, aggregating results from over 100 security vendors and intelligence providers.  

VirusX provides:  
- **Network insights**: WHOIS, SSL certificates, DNS resolution, and registration data.  
- **Relationship analysis**: linked files, domains, and IPs.  
- **Historical lookups**: DNS records, WHOIS data, SSL certificates.  
- **Subdomain discovery**: enumerate and check statuses.  
- **Passive DNS replication**: map domain-to-IP changes over time.  
- **Detected URL tracking**: with WaybackURL historical context.  
- **Sample analysis**: download history, detection ratio, file types, SHA scans.  

---

## 🎯 Key Features

### 🔍 File & URL Scanning
- Upload or submit URLs for deep scanning.  
- Aggregates results from 100+ vendors.  
- SHA-based deduplication with historical context.

<img width="962" height="953" alt="image" src="https://github.com/user-attachments/assets/4d559ed5-bf5c-48bb-acfa-dc684cde40c1" />


### 🌐 Domain & IP Intelligence
- WHOIS & registration details.  
- SSL/TLS certificate history.  
- Subdomain enumeration & live status checks.  
- IP resolution with related domains.  

<img width="888" height="953" alt="image" src="https://github.com/user-attachments/assets/de549225-cd7d-46a6-a223-f3dd947427e6" />

### 📊 Relationship Mapping
- Linked communicating files.  
- Passive DNS data replication.  
- File referrals & detection timelines.

<img width="888" height="953" alt="image" src="https://github.com/user-attachments/assets/31b7a52c-2382-47ae-a344-7d1d4276aacb" />


### 🕒 Historical Analysis
- Wayback URL integration for past snapshots.  
- Historical DNS lookups.  
- Archived SSL certificates.

  <img width="888" height="953" alt="image" src="https://github.com/user-attachments/assets/f3448fd6-e750-48ad-b72d-8530e1ca6c6c" />


### 🛡️ Threat Categorization
- Safety verdicts for URLs/files.  
- Detection ratios across vendors.  
- Vendor-by-vendor breakdowns.

<img width="888" height="953" alt="image" src="https://github.com/user-attachments/assets/9eaf41fe-f1ef-402d-8902-b2571912e7d2" />


---

## 🏗️ Architecture

```mermaid
graph TB
    IP[IP Addresses] --> DB1[Save to DB]
    DB1 --> REV[Reverse IP Lookup via API: Hackertarget, SecurityTrails, ViewDNS]
    REV --> OTHER[Other domains hosted on the server]
    OTHER --> DB2[Save to DB]

    SUB[Subdomains] --> DB3[Save to DB]
    DB3 --> COMP[Compare with domains of URL, if missing add to DB]
    COMP --> HTTPX[Use HTTPx to get domain status]
    HTTPX --> DB4[Save to DB]

    URLS[URLs] --> DB5[Save to DB]
    DB5 --> WAY[Send them to WaybackURL]
    WAY --> EXTRACT[Extract domains]
    EXTRACT --> COMP

    FILES[File Hashes] --> DB6[Save to DB]
     
 ```


## 🚀 Technology Stack
- **Backend:** Ruby on Rails
- **Frontend:** HTML, CSS, JavaScript
- **Database:** MongoDB
- **Deployment:** in progress
- **Others:** REST APIs, Active Storage

---

## ⚡ Quick Start
1. **Clone the repository**
   ```bash
   git clone https://github.com/Esra2brahmi/virus_total_clone2.git
   cd virus_total_clone2
   ```

2. **Install dependencies**
   ```bash
   bundle install
   yarn install
   ```

3. **Set up the database**
   ```bash
   rails db:create
   rails db:migrate
   rails db:seed
   ```

4. **Run the server**
   ```bash
   rails server
   ```

5. Open the app at:  
   👉 http://localhost:3000



## 🛣️ Feature Ro
- [ ] 🔮 **Predictive Analytics** – anomaly detection + predictive scoring for emerging threats.  
- [ ] 🌐 **Global Threat Map** – visualize live attacks, IP sources, and malware campaigns worldwide.    
- [ ] 🔍 **Deep Web & Dark Web Monitoring** – detect stolen data, malware kits, and C2 infrastructure.  
- [ ] 📱 **Mobile App Integration** – lightweight scanning & alerts directly on iOS/Android.  
- [ ] 🕵️ **Collaborative Threat Sharing** – share findings with SOC teams & research communities.  
- [ ] ☁️ **Cloud-Native Scaling** – distributed scanning with Kubernetes & serverless pipelines.  
  

---

## 🏗️ Built In
Made with ❤️ using **Ruby on Rails** and open-source tools.

