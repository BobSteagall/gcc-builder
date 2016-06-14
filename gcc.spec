Name:       kewb-gcc%{gcc_tag}
Version:    %{gcc_version}
Release:    %{gcc_rpm_release}

Summary:    Custom GCC %{gcc_version} build by KEWB
License:    GPL
Group:      Development Tools
Vendor:     KEWB Enterprises

AutoReq:        0
ExclusiveArch:  %{product_arch}
ExclusiveOS:    %{product_os}

%define debug_package %{nil}
%define __strip /bin/true

%description
This RPM provides a customized, modular installation of GCC %{gcc_version}.


%prep


%build


%pre


%install

rm -rf $RPM_BUILD_ROOT

BR_DIR=%{build_root_dir}
IREL_DIR=%{gcc_install_reldir}
VERSION=%{gcc_version}
TAG=%{gcc_tag}

mkdir -p $RPM_BUILD_ROOT/usr/local/bin
mkdir -p $RPM_BUILD_ROOT/$IREL_DIR

cp -pv  $BR_DIR/usr/local/bin/setenv-for-gcc$TAG.sh            $RPM_BUILD_ROOT/usr/local/bin
cp -pv  $BR_DIR/usr/local/bin/restore-default-paths-gcc$TAG.sh $RPM_BUILD_ROOT/usr/local/bin
cp -rpv $BR_DIR/$IREL_DIR/*                                    $RPM_BUILD_ROOT/$IREL_DIR

cd $RPM_BUILD_ROOT/usr/local/bin

ln -s -v /usr/local/gcc/$VERSION/bin/gcc gcc$TAG
ln -s -v /usr/local/gcc/$VERSION/bin/g++ g++$TAG

touch -h -r setenv-for-gcc$TAG.sh gcc$TAG
touch -h -r setenv-for-gcc$TAG.sh g++$TAG
touch -h -r setenv-for-gcc$TAG.sh $RPM_BUILD_ROOT/$IREL_DIR

exit 0


%post

exit 0


%preun

exit 0


%postun
##- Note that %postun also gets called when upgrading.  We have to check the
##  argument passed to %postun (the number of copies of the RPM installed after
##  this is run) to determine whether this is an upgrade, or a removal.  "0"
##  means removal, and >0 means upgrade

if [ "$1" = "0" ]; then
    VERSION=%{gcc_version}
    TAG=%{gcc_tag}
fi

exit 0

%verifyscript

%clean

rm -rf $RPM_BUILD_ROOT
exit 0


%files

%ifos freebsd
%attr(-,root,wheel) /usr/local/bin/setenv-for-gcc%{gcc_tag}.sh
%attr(-,root,wheel) /usr/local/bin/restore-default-paths-gcc%{gcc_tag}.sh
%attr(-,root,wheel) /usr/local/bin/gcc%{gcc_tag}
%attr(-,root,wheel) /usr/local/bin/g++%{gcc_tag}
%attr(-,root,wheel) /usr/local/gcc/%{gcc_version}
%else
%attr(-,root,root) /usr/local/bin/setenv-for-gcc%{gcc_tag}.sh
%attr(-,root,root) /usr/local/bin/restore-default-paths-gcc%{gcc_tag}.sh
%attr(-,root,root) /usr/local/bin/gcc%{gcc_tag}
%attr(-,root,root) /usr/local/bin/g++%{gcc_tag}
%attr(-,root,root) /usr/local/gcc/%{gcc_version}
%endif


%config

%doc

%changelog
