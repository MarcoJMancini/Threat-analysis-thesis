#!/usr/bin/env bash


arg1="${1:-}"
arg2="${2:-}"

echo "arg1 " $arg1
echo "arg2 " $arg2

      if [ -z "$arg1"  ]
      then
        echo "No parameter set. Options are [setup <server>, install, start]"
      else

      if [ $arg1 = "install" ]
      then
        apt update ; apt install wget vim -y

        wget https://artifacts.elastic.co/downloads/beats/packetbeat/packetbeat-7.4.0-amd64.deb
        dpkg -i packetbeat-7.4.0-amd64.deb


        wget https://artifacts.elastic.co/downloads/beats/auditbeat/auditbeat-7.4.0-amd64.deb
        dpkg -i auditbeat-7.4.0-amd64.deb



        export OSQUERY_KEY=1484120AC4E9F8A1A577AEEE97A80C63C9D8B80B
        apt-key adv --keyserver keyserver.ubuntu.com --recv-keys $OSQUERY_KEY
        add-apt-repository 'deb [arch=amd64] https://pkg.osquery.io/deb deb main'
        apt-get  update
        apt-get install osquery -y


        wget https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-7.4.0-amd64.deb
        dpkg -i filebeat-7.4.0-amd64.deb
      fi


      if [ $arg1 = "setup" ]
      then
        echo "Doing setup"

        if [ -z "$arg2"  ]
        then
          arg2="locahost"
        else
          echo "arg2 " $arg2
        fi

      #Load Kibana
      sed 's/  #host: "'$arg2':5601"/  host: "'$arg2':5601"/' filebeat_example.yml > temp.txt; cp temp.txt /etc/filebeat/filebeat.yml
      sed 's/  #host: "'$arg2':5601"/  host: "'$arg2':5601"/' packetbeat_example.yml > temp.txt; cp temp.txt /etc/packetbeat/packetbeat.yml
      sed 's/  #host: "'$arg2':5601"/  host: "'$arg2':5601"/' auditbeat_example.yml > temp.txt; cp temp.txt /etc/auditbeat/auditbeat.yml

      # Loading
      filebeat setup
      packetbeat setup --dashboards
      auditbeat setup --dashboards

      fi

      if [ $arg1 = "start" ]
      then
        service filebeat start
        service packetbeat start
        service auditbeat start
      fi

fi
