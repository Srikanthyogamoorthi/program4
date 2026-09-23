#!/bin/bash

# SELinux Access Denial Practical
# Student Name:
# Register Number:

echo "===== SELinux Status ====="
sestatus

echo "===== Creating Web Directory ====="
mkdir -p /var/www/html/testdir
echo "===== Creating HTML File ====="
echo "<h1>SELinux Access Test</h1>" > /var/www/html/testdir/index.html

echo "===== Setting Linux Permissions ====="
chmod 755 /var/www/html/testdir
chmod 644 /var/www/html/testdir/index.html

echo "===== Checking Initial Context ====="
ls -Z /var/www/html/testdir/index.html

echo "===== Assigning Wrong SELinux Context ====="
chcon -t user_home_t /var/www/html/testdir/index.html
echo "===== Checking Wrong Context ====="
ls -Z /var/www/html/testdir/index.html

echo "===== Checking AVC Denials ====="
# Simulate httpd access attempt (or trigger curl if service running)
curl -s http://localhost/testdir/index.html > /dev/null
ausearch -m avc -ts recent || tail -n 20 /var/log/audit/audit.log | grep "denied"
echo "===== Correcting SELinux Context ====="
restorecon -v /var/www/html/testdir/index.html
# Alternative explicit method:
# chcon -t httpd_sys_content_t /var/www/html/testdir/index.html

echo "===== Checking Correct Context ====="
ls -Z /var/www/html/testdir/index.html

echo "===== Practical Completed ====="
