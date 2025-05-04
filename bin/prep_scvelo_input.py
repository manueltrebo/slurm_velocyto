#!/usr/bin/env python

import os
import argparse
import scanpy as sc
import scvelo as scv
import anndata as ad
from scipy import io
from scipy.sparse import coo_matrix, csr_matrix


def rename_barcodes(input_loom, sample_ids):
    # Function renames the barcodes in the loom file according to the <cohort-sampleID-barcode> 
    # convention (in order to be merged with the corresponding H5AD in the downstream analysis):
    ldata = sc.read_loom(input_loom)
    barcodes = [bc.split(':')[1] for bc in ldata.obs.index.tolist()]
    barcodes = [bc[0:len(bc) - 1] + "_" + sample_ids for bc in barcodes]
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

    #rename the barcodes accordingly
    final_ldata = rename_barcodes(input_loom, s_id)
    #write final files as h5ad and looms
    final_ldata.write(out_dir + s_id + '.h5ad')
    #uncomment if loom files are needed:
    #final_ldata.write_loom(out_dir + s_id + '.loom')