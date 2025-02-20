import numpy as np
import nrrd
import os
import argparse
 
parser = argparse.ArgumentParser(description='Correct for missing nrrd info.',
                                 formatter_class=argparse.ArgumentDefaultsHelpFormatter)
parser.add_argument("DATASET_NAME", help="DATASET_NAME")
parser.add_argument("SERVER", help="SERVER")
parser.add_argument("ANALYZER", help="ANALYZER")
args = parser.parse_args()
config = vars(args)
print(config)

DATASET_NAME = config['DATASET_NAME']
SERVER = config['SERVER']
ANALYZER = config['ANALYZER']


data, header = nrrd.read(os.path.join(f"/nfs/data{SERVER}/chuyu/data/{DATASET_NAME}", f"{DATASET_NAME}_ds_stack_mean.nrrd"))


# Define pixel spacing in X, Y, Z directions
pixel_spacing = [1.0, 1.0, 2.0]  


header["space directions"] = np.array([
    [pixel_spacing[0], 0.0, 0.0],  # X-axis spacing
    [0.0, pixel_spacing[1], 0.0],  # Y-axis spacing
    [0.0, 0.0, pixel_spacing[2]],  # Z-axis spacing
])
header["space units"] = ["microns", "microns", "microns"]  # Set units explicitly
header["space dimension"] = 3
header["type"]='int'

print(header)


data_int8 = (255*data/np.max(data)).astype(np.int8);


# Save to an NRRD file
nrrd.write(os.path.join(f"/nfs/data{SERVER}/chuyu/data/{DATASET_NAME}", f"{DATASET_NAME}_ds_stack_mean_8bits.nrrd"), data_int8, header)

print("NRRD file saved successfully with specified pixel spacing.")