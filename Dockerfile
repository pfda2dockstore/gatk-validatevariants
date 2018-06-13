# Generated by precisionFDA exporter (v1.0.3) on 2018-06-13 23:02:19 +0000
# The asset download links in this file are valid only for 24h.

# Exported app: gatk-validatevariants, revision: 11, authored by: adam.halstead
# https://precision.fda.gov/apps/app-F0g2gp80BZ1F02V41GJfx52Z

# For more information please consult the app export section in the precisionFDA docs

# Start with Ubuntu 14.04 base image
FROM ubuntu:14.04

# Install default precisionFDA Ubuntu packages
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y \
	aria2 \
	byobu \
	cmake \
	cpanminus \
	curl \
	dstat \
	g++ \
	git \
	htop \
	libboost-all-dev \
	libcurl4-openssl-dev \
	libncurses5-dev \
	make \
	perl \
	pypy \
	python-dev \
	python-pip \
	r-base \
	ruby1.9.3 \
	wget \
	xz-utils

# Install default precisionFDA python packages
RUN pip install \
	requests==2.5.0 \
	futures==2.2.0 \
	setuptools==10.2

# Add DNAnexus repo to apt-get
RUN /bin/bash -c "echo 'deb http://dnanexus-apt-prod.s3.amazonaws.com/ubuntu trusty/amd64/' > /etc/apt/sources.list.d/dnanexus.list"
RUN /bin/bash -c "echo 'deb http://dnanexus-apt-prod.s3.amazonaws.com/ubuntu trusty/all/' >> /etc/apt/sources.list.d/dnanexus.list"
RUN curl https://wiki.dnanexus.com/images/files/ubuntu-signing-key.gpg | apt-key add -

# Install app-specific Ubuntu packages
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y \
	openjdk-7-jre-headless

# Download app assets
RUN curl https://dl.dnanex.us/F/D/xPq6B7Pk4f6608F5zy64GJJgf7pJ05gFjVqFFZV6/GATK-3.5.tar | tar xf - -C / --no-same-owner --no-same-permissions
RUN curl https://dl.dnanex.us/F/D/Yqz8Gk858jbv3Z0pqF3zY70yQ3VQB7Fy1z4g2VPx/grch37-fasta.tar.gz | tar xzf - -C / --no-same-owner --no-same-permissions
RUN curl https://dl.dnanex.us/F/D/G9FyK5K7q21Z0qgJ0yp6490YPjf6kp87Y9jx61x1/hs37d5-fasta.tar.gz | tar xzf - -C / --no-same-owner --no-same-permissions

# Download helper executables
RUN curl https://dl.dnanex.us/F/D/0K8P4zZvjq9vQ6qV0b6QqY1z2zvfZ0QKQP4gjBXp/emit-1.0.tar.gz | tar xzf - -C /usr/bin/ --no-same-owner --no-same-permissions
RUN curl https://dl.dnanex.us/F/D/bByKQvv1F7BFP3xXPgYXZPZjkXj9V684VPz8gb7p/run-1.2.tar.gz | tar xzf - -C /usr/bin/ --no-same-owner --no-same-permissions

# Write app spec and code to root folder
RUN ["/bin/bash","-c","echo -E \\{\\\"spec\\\":\\{\\\"input_spec\\\":\\[\\{\\\"name\\\":\\\"vcf_in\\\",\\\"class\\\":\\\"file\\\",\\\"optional\\\":false,\\\"label\\\":\\\"Input\\ VCF\\ file\\\",\\\"help\\\":\\\"VCF\\ file\\ to\\ validate\\\",\\\"default\\\":\\\"file-F0Pvpx80g6KZyqf7F9z4QyQJ\\\"\\},\\{\\\"name\\\":\\\"command_args\\\",\\\"class\\\":\\\"string\\\",\\\"optional\\\":true,\\\"label\\\":\\\"Command-line\\ Arguments\\\",\\\"help\\\":\\\"Command-line\\ Arguments\\\"\\},\\{\\\"name\\\":\\\"ref_genome\\\",\\\"class\\\":\\\"string\\\",\\\"optional\\\":false,\\\"label\\\":\\\"Reference\\ genome\\\",\\\"help\\\":\\\"Specify\\ reference\\ genome\\\",\\\"choices\\\":\\[\\\"grch37\\\",\\\"hs37d5\\\"\\]\\},\\{\\\"name\\\":\\\"dbsnp_in\\\",\\\"class\\\":\\\"file\\\",\\\"optional\\\":true,\\\"label\\\":\\\"dbSNP\\ file\\\",\\\"help\\\":\\\"dbSNP\\ file\\\"\\}\\],\\\"output_spec\\\":\\[\\],\\\"internet_access\\\":true,\\\"instance_type\\\":\\\"baseline-8\\\"\\},\\\"assets\\\":\\[\\\"file-BvYzqJQ03vv66X10j8XgG21x\\\",\\\"file-Bk5xvzQ0qVb5k0VYzZQG7BXJ\\\",\\\"file-Bk5y43Q0qVb0gjfqY8f9k4g8\\\"\\],\\\"packages\\\":\\[\\\"openjdk-7-jre-headless\\\"\\]\\} \u003e /spec.json"]
RUN ["/bin/bash","-c","echo -E \\{\\\"code\\\":\\\"dbsnp_in_args\\=\\'\\'\\\\nif\\ \\[\\ -n\\ \\\\\\\"\\$dbsnp_in\\\\\\\"\\ \\]\\;\\ then\\\\n\\ dbsnp_in_args\\=\\\\\\\"--dbsnp\\ \\$dbsnp_in_path\\\\\\\"\\\\nfi\\\\njava\\ -jar\\ GenomeAnalysisTK.jar\\ \\\\\\\\\\\\n\\ \\ -T\\ ValidateVariants\\ \\\\\\\\\\\\n\\ \\ \\ -R\\ \\\\\\\"\\$ref_genome\\\\\\\".fa\\ \\\\\\\\\\\\n\\ \\ \\ -V\\ \\\\\\\"\\$vcf_in_path\\\\\\\"\\ \\\\\\\\\\\\n\\ \\ \\ \\$dbsnp_in_args\\ \\\\\\\\\\\\n\\ \\ \\ \\$command_args\\\"\\} | python -c 'import sys,json; print json.load(sys.stdin)[\"code\"]' \u003e /script.sh"]

# Create directory /work and set it to $HOME and CWD
RUN mkdir -p /work
ENV HOME="/work"
WORKDIR /work

# Set entry point to container
ENTRYPOINT ["/usr/bin/run"]

VOLUME /data
VOLUME /work