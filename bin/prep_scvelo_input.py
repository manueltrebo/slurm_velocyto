#!/usr/bin/env python

import os
import argparse
import scvelo as scv
import anndata as ad
from scipy import io
from scipy.sparse import coo_matrix, csr_matrix

# def split_id(s, sep):
#     # Sting manipulation of the input ID according to
#     # the <cohort_sampleID-> convention
#     all_split = s.split(sep)
#     return sep.join(all_split[0:2]) + "-" + all_split[2]

def rename_barcodes(loom_file, sample_ids):
    # Function renames the barcodes in the loom file according to the <cohort-sampleID-barcode> 
    # convention (in order to be merged with the corresponding H5AD in the downstream analysis):
    ldata = scv.read(input_loom)
    barcodes = [bc.split(':')[1] for bc in ldata.obs.index.tolist()]
    barcodes = [sample_ids + '-' + bc[0:len(bc)-1]  for bc in barcodes]
    ldata.obs.index = barcodes
    ldata.obs.index.rename("CellID", inplace=True)
    return ldata

if __name__ == '__main__':
    parser = argparse.ArgumentParser(
                    prog='Sample sheet parser',
                    description='convert loom file\'s index',
                    epilog='Print this message and exit')

    parser.add_argument('-i', '--input')
    parser.add_argument('-s', '--sample_id')
    parser.add_argument('-o', '--out_dir')
    args = parser.parse_args()
    input_loom = args.input
    s_id = args.sample_id
    out_dir = args.out_dir
 
    if (out_dir[-1] != '/'):
        out_dir = out_dir + '/'

    # sanitised_id = split_id(s_id, "_")
    final_ldata = rename_barcodes(input_loom, s_id)
    final_ldata.write_loom(out_dir + s_id + '.loom')