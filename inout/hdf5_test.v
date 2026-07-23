module inout

import os
import vsl.inout.h5

const hdf5_test_dir = os.join_path(os.vtmp_dir(), 'vsl', 'inout')
const hdf5_test_file = os.join_path(hdf5_test_dir, 'roundtrip.h5')

fn test_hdf5_dataset_round_trip() ! {
	if !os.exists_in_system_path('h5dump') {
		eprintln('HDF5 test skipped: h5dump is not available')
		return
	}

	os.mkdir_all(hdf5_test_dir)!
	defer {
		os.rmdir_all(hdf5_test_dir) or {}
	}

	expected := [f64(1.25), -2.5, 3.75]
	file := h5.Hdf5File.new(hdf5_test_file)!
	assert file.write_dataset1d('values', expected)! >= 0
	file.close()

	mut actual := []f64{len: 1}
	read_file := h5.open_file(hdf5_test_file)!
	read_file.read_dataset1d('values', mut actual)
	read_file.close()

	assert actual == expected
}
