baseCommand: []
class: CommandLineTool
cwlVersion: v1.0
id: gatk-validatevariants
inputs:
  command_args:
    doc: Command-line Arguments
    inputBinding:
      position: 2
      prefix: --command_args
    type: string?
  dbsnp_in:
    doc: dbSNP file
    inputBinding:
      position: 4
      prefix: --dbsnp_in
    type: File?
  ref_genome:
    doc: Specify reference genome
    inputBinding:
      position: 3
      prefix: --ref_genome
    type: string
  vcf_in:
    doc: VCF file to validate
    inputBinding:
      position: 1
      prefix: --vcf_in
    type: File
label: GATK ValidateVariants
outputs: {}
requirements:
- class: DockerRequirement
  dockerOutputDirectory: /data/out
  dockerPull: pfda2dockstore/gatk-validatevariants:11
s:author:
  class: s:Person
  s:name: Adam Halstead
