#
# Cookbook Name:: typesafe-stack
# Recipe:: default
#
# Copyright 2012, Gilles Cornu
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#

apt_packaging = platform?("debian", "ubuntu")
yum_packaging = platform?("redhat", "centos", "scientific", "fedora",  "suse", "amazon")

include_recipe "java"
include_recipe "apt" if apt_packaging
include_recipe "yum" if yum_packaging 

if yum_packaging

  # Add the RPM/YUM Repository
  yum_repository "typesafe" do
    url "http://rpm.typesafe.com/"
    action :add
  end

elsif apt_packaging

  # Add the DEB/APT Repository
  apt_repository "typesafe" do
    uri "http://apt.typesafe.com/"
    distribution "unicorn"
    components ["main"]
    #key "https://somewhere.typesafe.com/.../typesafe-repo-public.asc" # there is no official web site to download this key.
    key "typesafe-repo-public.asc" # The public key of this repository is packaged in the cookbook
    action :add
  end

end

# Install "all" (sbt + g8) 
package "typesafe-stack"

