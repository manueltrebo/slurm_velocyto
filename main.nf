#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { VELOCYTO } from './workflows/velocyto'

workflow {

    VELOCYTO()
}
