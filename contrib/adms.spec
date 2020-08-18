Name:           ADMS
Version:        2.3.0
Release:        1%{?dist}
Summary:        code generator that converts electrical compact device models.. transforms Verilog-AMS code into other target languages
License:        GPL
URL:            https://github.com/Qucs/ADMS
Source0:        ADMS-2.3.0.tar.gz

#BuildRequires:  
#Requires:       

%description


%prep
%setup -q


%build
%configure
make %{?_smp_mflags}


%install
rm -rf $RPM_BUILD_ROOT
%make_install


%files
%doc
%{_bindir}/*
/usr/include/adms/*
/usr/lib64/*
/usr/share/man/man1/*


%changelog
