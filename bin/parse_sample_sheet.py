#!/usr/bin/env python

import pandas as pd
import argparse
import os

def process_csv(input_file, output_file):
    try:
        # Read the CSV file into a Pandas DataFrame
        df = pd.read_csv(input_file)

        # Initialize a list to store valid rows
        valid_rows = []

        # Iterate through each row in the DataFrame
        for index, row in df.iterrows():
            # Concatenate the first two columns with "_"
            key = f"{row.iloc[0]}_{row.iloc[1]}"
            # Get the file path from the third column
            file_path = row.iloc[2]

            # Check if the file exists
            if os.path.isfile(file_path):
                # Append the concatenated key and the file path to the valid rows list
                valid_rows.append([key, file_path])
            else:
                raise FileNotFoundError(f"File not found: {file_path}")

        # Create a new DataFrame with the valid rows
        result_df = pd.DataFrame(valid_rows, columns=['Sample_ID', 'File_Path'])

        # Save the result DataFrame to a new CSV file
        result_df.to_csv(output_file, index=False)

        return f"CSV file with valid entries saved to {output_file}"
    except FileNotFoundError as e:
        return f"Error: {str(e)}"

if __name__ == '__main__':
    parser = argparse.ArgumentParser(
                    prog='Sample sheet parser',
                    description='Sanitize input CSV file',
                    epilog='Text at the bottom of help')

    parser.add_argument('-i', '--input')
    parser.add_argument('-o', '--output')
    args = parser.parse_args()
    # Specify the path to CSV file
    input_csv = args.input
    output_csv = args.output

    # Call the function and print the result
    result = process_csv(input_csv, output_csv)
    print(result)