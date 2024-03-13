#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    NAMED MODULES FOR PIPELINE
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

include { PARSE_INPUT   } from '../modules/parse_input'
include { RUN_VELO      } from '../modules/run_velo'
include { RUN_VELO_10X  } from '../modules/run_velo_10x'
include { RUN_VELO_BD  } from '../modules/run_velo_BD'
include { CONVERT_LOOM  } from '../modules/convert_loom'

//
// WORKFLOW: Run main analysis pipeline
//
ch_input_csv = file(params.input_csv)
ch_gtf = file(params.gtf_file)
ch_mask_repeats = file(params.masked_repeats)
sam_th = params.sam_threads
out_dir = params.out_dir
// Returns error:
// sam_mem = "params.sam_mem"

workflow VELOCYTO {

    // Run to sanitize input CSV file
    PARSE_INPUT(ch_input_csv)

    // Create velo input ch
    velo_input = PARSE_INPUT.out
                .splitCsv(header:true)
                .map{row -> [row.Sample_ID,
                            file(row.BAM_File_Path),
                            file(row.BCL_File_Path)
                        ]
                    }

    // Run velocyto for each sample (excluded the samtools-threads param)
    if ( params.platform == "BD" ) {
        RUN_VELO_BD(velo_input,
            ch_gtf,
            ch_mask_repeats,
            sam_th,
            out_dir)
    } else if ( params.platform == "10x" ) {
        // TODO: implement for cellranger ouput directory
        RUN_VELO_10X(velo_input,
            ch_gtf,
            ch_mask_repeats,
            sam_th,
            out_dir)
    } else {
        RUN_VELO(velo_input,
            ch_gtf,
            ch_mask_repeats,
            sam_th,
            out_dir)
    }

    // Change the loom's file obs.index to match the H5AD files
    // (used for downstream merging - tailored after the cohort's naming convention)
    if ( params.convert_loom == true ) {
        if ( params.platform == "BD" ) {
            CONVERT_LOOM(RUN_VELO_BD.out.ch_loom,
                    params.custom_loom_dir)
            // out_dir)
        } else if ( params.platform == "10x" ) {
            CONVERT_LOOM(RUN_VELO_10X.out.ch_loom,
                    params.custom_loom_dir)
        } else {
            CONVERT_LOOM(RUN_VELO.out.ch_loom,
                    params.custom_loom_dir)
        }   
    } 
}