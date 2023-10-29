#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    NAMED MODULES FOR PIPELINE
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

include { PARSE_INPUT       } from '../modules/parse_input'
include { RUN_VELO      } from '../modules/run_velo'

//
// WORKFLOW: Run main analysis pipeline
//
ch_input_csv = file(params.input_csv)
ch_gtf = file(params.gtf_file)
ch_mask_repeats = file(params.masked_repeats)
sam_th = "10"
sam_mem = "4"
out_dir = params.out_dir


workflow VELOCYTO {

    // Run to sanitize input CSV file
    PARSE_INPUT(ch_input_csv)

    // Create velo input ch
    velo_input = PARSE_INPUT.out
                .splitCsv(header:true)
                .map{row -> [row.Sample_ID, file(row.File_Path)]}

    // Run velocyto for each sample
    RUN_VELO(velo_input,
            ch_gtf,
            ch_mask_repeats,
            sam_th,
            sam_mem,
            out_dir)
}