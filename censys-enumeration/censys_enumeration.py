#!/usr/bin/env python

# A script to extract subdomains/emails from related SSL/TLS certificates using Censys
# You'll need Censys API ID and API Secret to be able to extract SSL/TLS certificates
# Needs censys module to run. pip install censys.

from __future__ import print_function

import logging
import re
import os
import sys
import json

logging.basicConfig(
    level=logging.INFO,
    format="%(message)s"
    )

__author__  = "Bharath(github.com/yamakira)"
__version__ = "0.1"
__purpose__ = '''Extract subdomains/emails for a domain from censys SSL/TLS certificate dataset'''

if "CENSYS_API_ID" in os.environ:
    CENSYS_API_ID = os.environ['CENSYS_API_ID'] # Add CENSYS_API_ID as environment variable
else:
    print("[!] No environmental variable with name CENSYS_API_ID. \
            Please add you Censys API ID to env variables")
    sys.exit(1)
if "CENSYS_API_SECRET" in os.environ:
    CENSYS_API_SECRET = os.environ['CENSYS_API_SECRET'] # Add CENSYS_API_SECRET as env variable
else:
    print("[!] No environmental variable with name CENSYS_API_SECRET. \
            Please add you Censys API Secret 1to env variables")
    sys.exit(1)

try:
    import censys.certificates
    import censys.ipv4
except ImportError:
    logging.info("\033[1;31m[!] Failed to import censys module. Run 'pip install censys'\033[1;m")
    sys.exit()

try:
    import click
except ImportError:
    logging.info("\033[1;31m[!] Failed to import click module. Run 'pip install click'\033[1;m")
    sys.exit()

json_report = {}
emails_found = []
subdomains_found = []

def get_certificates():
    try:
        if not CENSYS_API_ID or not CENSYS_API_SECRET:
            logging.info("\033[1;31m[!] API KEY or Secret for Censys not provided.\033[1;m" \
                        "\nYou'll have to provide them in the script") 
            sys.exit()
        logging.info("[+] Extracting certificates using Censys")
        censys_certificates = censys.certificates.CensysCertificates(CENSYS_API_ID, CENSYS_API_SECRET)
        return censys_certificates
    except censys.base.CensysUnauthorizedException:
        logging.info('\033[93m[!] Your Censys credentials look invalid.\n\033[1;m')
        sys.exit(1)
    except censys.base.CensysRateLimitExceededException:
        logging.info('\033[93m[!] Looks like you exceeded your Censys account limits rate. Exiting\n\033[1;m')
        sys.exit(1)

def get_subdomains(domain, certificates):
    unique_subdomains = []
    logging.info("[+] Extracting sub-domains for {} from certificates".format(domain.rstrip()))
    try:
        certificate_query = 'parsed.names: {}'.format(domain)
        certificates_search_results = certificates.search(certificate_query, fields=['parsed.names'])
    except CensysException:
        logging.info('\033[93m[!] Error while fetching results from Censys.\n\033[1;m')
        sys.exit(1)
    for search_result in certificates_search_results:
        subdomains_found.extend(search_result['parsed.names'])
    for subdomain in subdomains_found:
        if '*' not in subdomain and subdomain.endswith(domain): 
            unique_subdomains.append(subdomain)
    return set(unique_subdomains)

def get_emails(domain, certificates):
    del emails_found[:]
    logging.info("[+] Extracting emails belonging to {} from SSL/TLS certificates".format(domain.rstrip()))
    try:
        certificate_query = 'parsed.names: {}'.format(domain)
    except CensysException:
        logging.info('\033[93m[!] Error while fetching results from Censys.\n\033[1;m')
        sys.exit(1)
    try:
        certificates_search_results = certificates.search(certificate_query, fields=['parsed.subject.email_address'])
    except KeyError:
        pass
    for search_result in certificates_search_results:
        try:
            emails_found.extend(search_result['parsed.subject.email_address'])
        except KeyError:
            pass
    return set(emails_found)

def print_subdomains(subdomains_found, domain):
    if len(subdomains_found) is 0:
        logging.info('[!] Did not find any email addresses')
        return
    logging.info("\033[92m[*] Total unique subdomains found for {}: {}\033[1;m".format(domain, len(subdomains_found)))
    for subdomain in sorted(subdomains_found):
        print(subdomain)

def print_emails(emails_found, domain):
    if len(emails_found) is 0:
        logging.info('[!] Did not find any email addresses')
        return
    logging.info("\033[92m[*] Total unique emails found for {}: {}\033[1;m".format(domain, len(emails_found)))
    for email in sorted(emails_found):
        print(email)

def write_to_json(domain,outfile):
    with open(outfile, 'w') as outfile:
        json.dump(json_report, outfile, default=str)
        file_path = os.path.abspath(outfile.name)
    logging.info("\033[1;32m[+] Results written to JSON file : {}\033[1;m".format(file_path))

def get_domains(domain_names_file):
    with open(domain_names_file) as f:
        domains = f.readlines()
    return domains

@click.command()
@click.argument('file',type=click.Path(exists=True))
@click.option('--verbose', is_flag=True,
                help="Verbose output")
@click.option('--subdomains/--no-subdomains', default=True,
                help='Enable/Disable subdomain enumeration')
@click.option('--emails/--no-emails', default=True, 
                help='Enable/Disable email enumeration')
@click.option('--outfile', nargs=1, type=str, default='json_results')

def main(emails, subdomains, verbose,file,outfile):
    domains = get_domains(file)
    certificates = get_certificates()
    for domain in domains:
        domain = domain.rstrip()
        if emails == True: # Only if emails enumeration is enabled
            emails_found = get_emails(domain,certificates)
            if verbose:
                print_emails(emails_found, domain)
        else:
            print("[*] Email enumeration disabled")
        if subdomains == True: # Only if sudomain enumeration is enabled
            subdomains_found = get_subdomains(domain,certificates)
            if verbose:
                print_subdomains(subdomains_found, domain)
        else:
            print("[*] Subdomain enumeration disabled")
        json_report[domain] = {"domain":domain,"emails":list(emails_found), "subdomains":list(subdomains_found)}
    write_to_json(domain, outfile) # Write the JSON report to file

if __name__ == '__main__':
    main()