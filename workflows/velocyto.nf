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

//
// WORKFLOW: Run main analysis pipeline
//
ch_input_csv = file(params.input_csv)
ch_gtf = file(params.gtf_file)
ch_mask_repeats = file(params.masked_repeats)
sam_th = "10"
// Returns error:
// sam_mem = "4"
out_dir = params.out_dir


workflow VELOCYTO {

    // Run to sanitize input CSV file
    PARSE_INPUT(ch_input_csv)

    // Create velo input ch
    if (out_dir == ""){
        velo_input = PARSE_INPUT.out
                .splitCsv(header:true)
                .map{row -> [row.Sample_ID,
                            file(row.BAM_File_Path),
                            file(row.BCL_File_Path),
                            file(row.BAM_File_Path).getParent()]}
    } else {
        velo_input = PARSE_INPUT.out
                .splitCsv(header:true)
                .map{row -> [row.Sample_ID,
                            file(row.BAM_File_Path),
                            file(row.BCL_File_Path),
                            out_dir]}
    }
    

    // Run velocyto for each sample - excluded the samtools-threads param
    if ( params.run_10x == false ) {
        RUN_VELO(velo_input,
                ch_gtf,
                ch_mask_repeats,
                sam_th)
                // out_dir)
    } else {
        RUN_VELO_10X(velo_input,
                ch_gtf,
                ch_mask_repeats,
                sam_th)
    }
}