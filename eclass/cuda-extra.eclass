# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: cuda-extra.eclass
# @MAINTAINER:
# Ștefan Talpalaru <stefantalpalaru@yahoo.com>
# @AUTHOR:
# Ștefan Talpalaru <stefantalpalaru@yahoo.com>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: Extra functions for CUDA packages
# @DESCRIPTION:
# This eclass contains extra functions to be used with CUDA packages.
# @EXAMPLE:
# inherit cuda-extra
# # Before running something requiring access to Nvidia dev nodes:
# cuda_check_permissions || die "Cannot access CUDA device. Aborting."

case ${EAPI} in
	7|8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ ! ${_CUDA_EXTRA_ECLASS} ]]; then
_CUDA_EXTRA_ECLASS=1

# @FUNCTION: cuda_check_permissions
# @DESCRIPTION:
# Check if we can write to Nvidia device nodes, after bypassing the sandbox.
cuda_check_permissions() {
	if ! SANDBOX_WRITE=/dev/nvidiactl test -w /dev/nvidiactl; then
		eerror
		eerror "Cannot access the GPU at \"/dev/nvidiactl\", after bypassing the sandbox."
		if ! groups | grep -wq video; then
			eerror "User \"$(id -nu)\" is not in the \"video\" group."
			eerror "Add it with \"usermod -a -G video $(id -nu)\"."
		fi
		eerror
		return 1
	fi
}

# @FUNCTION: cuda_get_host_native_arch
# @DESCRIPTION:
# Get the host's CUDA architecture number (E.g.: "86"). Overridden by the
# "CUDAARCHS" environment variable, which can look like this: "75;86;89".
cuda_get_host_native_arch() {
	if [[ -n ${CUDAARCHS} ]]; then
		echo "${CUDAARCHS}"
		return
	fi

	cuda_add_sandbox -w
	cuda_check_permissions || die "Cannot access CUDA device. Aborting. You can set \"CUDAARCHS\" in /etc/portage/make.conf to avoid having to query the host device."
	__nvcc_device_query || eerror "failed to query the native device"
}
fi
