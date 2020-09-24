<?php /* ----------------------------------------------------------------------
                                        DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
   Title: PHP Simple network services monitoring application

   Date : 24/05/2007
   By   : FSL
---------------------------------------------------------------------------- */

include_once(dirname(__FILE__).'/definitions.inc.php');


/**********************************************************************
*                      PSI - PHP Simple Informer                      *
*                              Version 1.1                            *
*                   By Pablo Godel - pablo@godel.com.ar               *
*                    http://www.godel.com.ar/psi/                     *
*                                                                     *
*  SUPPORT FURTHER DEVELOPMENT, DONATE: http://www.godel.com.ar/psi/  *
*                                                                     *
*                                                                     *
*          This is code is distributed under the GPL license          *
**********************************************************************/



/*
Class that holds a Psi contact.
*/
class Psi_contact
{
        var $id;
        var $name;
        var $contact_method;

        function Psi_contact($id, $name, $contact)
        {
                $this->id = $id;
                $this->name = $name;
                $this->contact_method = $contact;
        }

        /**
        * @return void
        * @param string $hostname
        * @param int $port
        * @param string $description
        * @desc Sends an alert to contact.
        */
        function send_alert($hostname, $port, $description = '')
        {
                // checks if it's an email address, I will add a better checking function when having more time.
                if (strstr($this->contact_method, "@"))
                {
                        // it's an email, let's send a message.
                        $today = date("m-d-Y H:i:s");
                        $subject = "PSI: $hostname:$port";
                        $body = "PSI: $hostname:$port\nDate: $today\n\n$description\n";
                        mail($this->contact_method, $subject, $body, 'From: '.PSI_FROM_EMAIL);
                } else {

                        // it's an external app. let's execute it.
                        exec($this->contact_method.' PSI: '.$hostname.':'.$port.' - '.$description.'"');
                }
        }
}


/*
Loads log messages to be displayed.
*/
class Logger
{
        var $filename;

        var $content = array();

        function Logger($filename)
        {
                $this->filename = $filename;
        }

        /**
        * @return void
        * @param string $host
        * @desc Loads log messages for all hosts, or if host is specified, then loads only messages for selected host.
        */
        function load($host = '')
        {
                if (!$fp = @fopen($this->filename, 'r'))
                {
                        echo "Cannot open ".$this->filename." for reading. Please check the permissions or run 'psi.php' to generate a log file.\n\n";
                        exit(1);
                }
                while (!feof($fp))
                {
                        $buffer = fgets($fp, 4096);
                        $arr = explode(chr(9), $buffer);
                        if (empty($host) || ($host == $arr[1]))
                        {
                                $this->content[] = $buffer;
                        }
                }

                fclose($fp);
        }
}


/*
Main Class. This is the class that has to be instantiated to run PSI.
Example:

include_once(dirname(__FILE__) .'/psi.inc.php');
$psi = new Psi();
$psi->load_config();
$psi->check();

*/
class Psi
{
        var $conf_file = CONFIG_FILE;
        var $conf;
        var $hosts = array();
        var $contacts = array();

        function Psi()
        {
                $this->check_log_dir();
        }

        /**
        * @return void
        * @desc Checks if Log directory exists.
        */
        function check_log_dir()
        {
                if (!file_exists(PSI_LOG_DIR))
                {
                        echo "Error: Cannot open log directory '".PSI_LOG_DIR."'!!!\n\n";
                        exit(1);
                }
        }

        /**
         * @return void
         * @desc Loads configuration file and populates all class properties.
         */
        function load_config()
        {
                $total_hosts = 0;
                $total_contacts = 0;

                if (!$fp_conf = fopen($this->conf_file, "r"))
                {
                        echo "Error: No config file ".$this->conf_file." found! Please, read the README file now!\n\n";
                        exit(1);
                }
                $conf_line = 0;
                while ($line = fgets($fp_conf, 1024))
                {
                        $conf_line++;
                        if ((substr($line, 0, 1) != "") && (substr($line, 0, 1) != "#"))
                        {
                                $array = explode(";", $line);
                                reset($array);
                                while (list($key, $val) = each($array))
                                {
                                        $array[$key] = trim($val);
                                }

                                switch($array[0]) {
                                        case "DEFAULT_TIMEOUT":
                                        $this->conf['default_timeout'] = $array[1];
                                        break;

                                        case "DEFAULT_CONTACT_ID":
                                        $this->conf['default_contact_id'] = $array[1];
                                        break;

                                        case "HOST":
                                        $total_hosts++;
                                        $hostname = $array[1];
                                        $port = $array[2];

                                        if (empty($port)) {
                                                echo "Configuration error: no port was defined in line $conf_line\n\n";
                                                exit(1);
                                        }
                                        $h = new Psi_host($hostname.$port, $hostname, $port, $array[3]);

                                        // add multple contacts separated by comma
                                        if (!empty($array[4]))
                                        {
                                                $arr = explode(',', $array[4]);
                                                reset($arr);
                                                while (list($key, $val) = each($arr))
                                                {
                                                        $h->add_contact($val);
                                                }
                                        }



                                        // check for additional parameters
                                        if (!empty($array[5]))
                                        {
                                                $arr = array();
                                                $arr = explode(',', $array[5]);
                                                reset($arr);
                                                while (list($key, $val) = each($arr))
                                                {
                                                        $arr2 = explode('=', $val);
                                                        reset($arr2);
                                                        $h->additional_parms[strtolower($arr2[0])] = $arr2[1];
                                                }
                                        }
                                        $this->hosts[$hostname.':'.$port] = $h;
                                        break;

                                        case "CONTACT":
                                        $total_contacts++;
                                        $contact_id = $array[1];
                                        if (empty($array[3])) {
                                                echo "Configuration error: no alert destination was defined in line $conf_line\n\n";
                                                exit(1);
                                        }
                                        $this->contacts[$contact_id] = new Psi_contact($contact_id, $array[2], $array[3]);

                                        break;

                                        case "WWW_USERID":
                                        case "WWW_PASSWD":
                                        $this->conf[ $array[0] ] = $array[1];
                                        break;

                                        default:

                                        break;
                                }
                        }
                }
                fclose($fp_conf);

                if (!$total_hosts) {
                        echo "Error: No HOST definitions where found in the config file. Check ".$this->conf_file." or read         the README file\n\n";
                        exit(1);
                }

                if (!$total_contacts) {
                        echo "Error: No CONTACT definitions where found in the config file. Check ".$this->conf_file." or         read the README file\n\n";
                        exit(1);
                }


                // if defaults are not set, take the hard settings.
                if (!empty($this->conf['default_timeout']))
                {
                        define('TIMEOUT', $this->conf['default_timeout']);
                }
                else
                {
                        define('TIMEOUT', DEFAULT_TIMEOUT);
                }


        } // END load_config()

        /**
         * @return void
         * @param host = '' unknown
         * @param port = '' unknown
         * @desc Check host if specified in $host, or goes through array of hosts and checks them.
         */
        function check($host = '', $port = '')
        {
                if (!empty($host) && !empty($port))
                {
                        $this->hosts[$host.':'.$port]->check();
                        return;
                }
                reset($this->hosts);
                while (list($key, $h) = each($this->hosts))
                {
                        $h->check($this->contacts);
                }

        }

}




/*
Class used to connect to a TCP port. Can be extended. for special services like mysql, http, https, etc.
*/
class Tcp_Connect
{
        var $host;
        var $port;
        var $timeout = DEFAULT_TIMEOUT;
        var $errno;
        var $errstr;
        var $_fp = false;
        var $result_data = array();

        /**
        * @return Tcp_Connect
        * @param string $host
        * @param int $port
        * @param int $timeout
        * @desc Connects to a TCP port.
        */
        function Tcp_Connect($host, $port = '', $timeout = '')
        {
                $this->host = $host;
                if (!empty($port))
                {
                        $this->port = $port;
                }
                if (!empty($timeout))
                {
                        $this->timeout = $timeout;
                }
        }

        /**
        * @return bool
        * @param bool $close
        * @desc Makes connection.
        */
        function connect($close = true)
        {
                if (empty($this->port) || empty($this->host))
                {
                        echo "Host/Port not provided.\n\n";
                        exit(1);
                }

                $this->_fp = fsockopen($this->host, $this->port, $this->errno, $this->errstr, $this->timeout);
                if(!$this->_fp) {
                        return $this->tcp_return(false);
                }

                if ($close)
                {
                        fclose($this->_fp);
                }
                return $this->tcp_return(true);
        }

        /**
        * @return array
        * @param bool $result
        * @desc Based on result, assembles array.
        */
        function tcp_return($result)
        {
                if ($result)
                {
                        $this->result_data = array(
                        'hostname'         => $this->host,
                        'port'                 => $this->port,
                        'timeout'        => $this->timeout,
                        'errno'         => 0,
                        'errstr'        => ''
                        );
                }
                else
                {
                        $this->result_data = array(
                        'hostname'         => $this->host,
                        'port'                 => $this->port,
                        'timeout'        => $this->timeout,
                        'errno'         => $this->errno,
                        'errstr'        => $this->errstr
                        );
                }
                return $result;
        }
}

/*
Class to connect to an HTTP service.
*/
class Tcp_HTTP extends Tcp_Connect
{
        var $url = '/';
        var $port = '80';

        function connect($url = '')
        {
                if (!empty($url))
                {
                        $this->url = $url;
                }

                if (!parent::connect(false))
                {
                        return $this->tcp_return(false);
                }

                fputs($this->_fp,"GET ".$this->url." HTTP/1.0\n\n");

                $line = '';
                while(!feof($this->_fp))
                {
                        $line .= fgets($this->_fp,128);
                }
                fclose($this->_fp);
                if (empty($line))
                {
                        return $this->tcp_return(false);
                }
                else
                {
                        return $this->tcp_return(true);
                }

        }
}

/*
Class to connect to an HTTPS service.
*/
class Tcp_HTTPS extends Tcp_Connect
{
        var $url = '/';
        var $method = HTTPS_DEFAULT_METHOD;
        var $curl_bin_path = '/usr/local/bin/curl';
        var $port = '443';

        function connect($url = '')
        {
                if (!empty($url))
                {
                        $this->url = $url;
                }

                if (strtolower(substr($this->url, 0, 5)) != 'https')
                {
                        $this->url = 'https://'.$this->host.(!empty($this->port) ? ':'.$this->port : '').(!empty($this->url) ? $this->url : '/');
                }

                switch($this->method)
                {
                        case 'openssl':

                        if (!function_exists('openssl_open'))
                        {
                                echo "OpenSSL support is not enabled.\n\n";
                                exit(1);
                        }

                        $this->_fp = fopen($this->url, 'r');

                        if (!$this->_fp)
                        {
                                $this->errstr = 'Could not open '.$this->url;
                                return $this->tcp_return(false);
                        }

                        $line = '';
                        while(!feof($this->_fp))
                        {
                                $line .= fgets($this->_fp,128);
                        }
                        echo $line;
                        fclose($this->_fp);
                        if (empty($line))
                        {
                                $this->errstr = $this->url.' returned an empty page.';
                                return $this->tcp_return(false);
                        }
                        else
                        {
                                return $this->tcp_return(true);
                        }
                        break;

                        case 'curl_functions':

                        if (!function_exists('curl_init'))
                        {
                                echo "Curl support is not enabled.\n\n";
                                exit(1);
                        }
                        $ch = curl_init();
                        curl_setopt($ch, CURLOPT_URL, $this->url);
                        curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
                        curl_setopt($ch, CURLOPT_TIMEOUT, $this->timeout);
                        curl_setopt($ch, CURLOPT_HEADER, 0);

                        $return_message = curl_exec($ch);

                        if (!empty($return_message))
                        {
                                curl_close($ch);
                                return $this->tcp_return(true);
                        }
                        $this->errno = curl_errno ($ch);
                        $this->errstr = curl_error($ch);
                        curl_close($ch);
                        return $this->tcp_return(false);

                        break;

                        default:
                        case 'curl_commandline':

                        if (!file_exists($this->curl_bin_path))
                        {
                                echo "Curl executable not found on ".$this->curl_bin_path."\n\n";
                                exit(1);
                        }
                        $command = $this->curl_bin_path.' -m '.$this->timeout.' "'.$this->url.'" -L --stderr -';

                        $return_message_array = array();
                        $return_number = 0;

                        exec($command, $return_message_array, $return_number);
                        $result = implode("", $return_message_array);
                        $this->errno = $return_number;

                        if ($this->errno)
                        {
                                $this->errstr = $result;
                                return $this->tcp_return(false);
                        }
                        else
                        {
                                return $this->tcp_return(true);
                        }

                        break;

                }

        }
}

/*
Class to connect to a MYSQL service.
*/
class Tcp_MYSQL extends Tcp_Connect
{
        var $db = '';
        var $user = 'root';
        var $pass = '';
        var $port = '3306';

        function connect($user = '', $pass = '', $db = '')
        {
                if (!empty($user))
                {
                        $this->user = $user;
                }
                if (!empty($pass))
                {
                        $this->pass = $pass;
                }
                if (!empty($db))
                {
                        $this->db = $db;
                }

                if (!function_exists('mysql_connect'))
                {
                        echo "MySQL support not enabled.\n\n";
                        exit(1);
                }

                if (!$res = mysql_connect($this->host.':'.$this->port, $this->user, $this->pass))
                {
                        $this->errno = mysql_errno($res);
                        $this->errstr = mysql_error($res);
                        if (empty($this->errstr))
                        {
                                $this->errstr = 'Could not connect to '.$this->host.':'.$this->port;
                        }
                        return $this->tcp_return(false);
                }

                if (!empty($this->db))
                {
                        if (!mysql_select_db($this->db, $res))
                        {
                                $this->errno = mysql_errno($res);
                                $this->errstr = mysql_error($res);
                                return $this->tcp_return(false);
                        }
                }
                return $this->tcp_return(true);
        }
}

/*
Class that holds host.
*/
class Psi_host
{
        var $id;
        var $name;
        var $port;
        var $timeout;
        var $contact_ids = array();
        var $additional_parms = array();

        function Psi_host($id, $name, $port, $timeout)
        {
                $this->id = $id;
                $this->name = $name;
                $this->port = $port;
                $this->timeout = $timeout;
        }

        /**
        * @return void
        * @param object $contact
        * @desc Adds a contact to this host.
        */
        function add_contact($contact)
        {
                $this->contact_ids[] = $contact;
        }

        /**
        * @return void
        * @param object[] $contacts
        * @param string $description
        * @desc Sends alert to contacts.
        */
        function send_alert($contacts, $description = '')
        {
                if ($this->host_status('check'))
                {
                        return;
                }
                reset($this->contact_ids);
                while (list($key, $id) = each($this->contact_ids))
                {
                        $contacts[$id]->send_alert($this->name, $this->port, $description);
                }
        }

        /**
        * @return string
        * @desc Returns list of contact ids separated by comma.
        */
        function list_contacts()
        {
                return implode(',', $this->contact_ids);
        }

        /**
        * @return void
        * @param object[] $contacts
        * @desc Checks host and if necessary sends an alert to contacts.
        */
        function check($contacts)
        {
                $c->errno = 0;
                $c->errstr = '';
                $result = false;

                if (empty($this->timeout))
                {
                        $this->timeout = TIMEOUT;
                }

                switch($this->port) {

                        case HTTP:
                        $c = new Tcp_HTTP($this->name, $this->port, $this->timeout);
                        $result = $c->connect($this->additional_parms['url']);
                        break;

                        case HTTPS:
                        $c = new Tcp_HTTPS($this->name, $this->port, $this->timeout);
                        $result = $c->connect($this->additional_parms['url']);
                        break;

                        case MYSQL:
                        $c = new Tcp_MYSQL($this->name, $this->port, $this->timeout);
                        $result = $c->connect($this->additional_parms['user'], $this->additional_parms['pass'], $this->additional_parms['db']);
                        break;

                        default:
                        $c = new Tcp_Connect($this->name, $this->port, $this->timeout);
                        $result = $c->connect();
                        break;
                }

                if (!$result)
                {
                        $this->send_alert($contacts, $c->errstr.' ('.$c->errno.')');

                        $this->log2file($c->result_data);
                        $this->host_status('on', $c->errstr);
                }
                elseif ($this->host_status('check'))
                {
                        $this->host_status('off');
                        $this->send_alert($contacts, "Service is back up.");
                }
        }


        /**
        * @return void
        * @param string[] $data
        * @desc Saves log messages into log file.
        */
        function log2file($data)
        {
                if (!$fp = fopen(PSI_LOG_FILE, 'a'))
                {
                        echo "Couldn't open ".PSI_LOG_FILE." for writing. Please check the permissions.\n\n";
                        exit(1);
                }
                $data = array_merge(array(date('Y-m-d H:i:s')), $data);
                $str = implode(chr(9), $data)."\n";
                fputs($fp, $str);
                fclose($fp);
        }


        /**
        * @return mixed
        * @param string $onoff
        * @param string $description
        * @desc Checks current status of host.
        */
        function host_status($onoff, $description = '')
        {
                $filename = PSI_LOG_DIR.'/'.$this->name.'_'.$this->port.'.status';
                switch($onoff)
                {
                        case 'extended_check':
                        if (file_exists($filename))
                        {
                                return file($filename);
                        }
                        else
                        {
                                return false;
                        }
                        break;

                        case 'check':
                        if (file_exists($filename))
                        {
                                return true;
                        }
                        else
                        {
                                return false;
                        }

                        break;

                        case 'on':
                        if (!$fp = fopen($filename, 'w'))
                        {
                                echo "Couldn't open ".$filename." for writing. Please check the permissions.\n\n";
                                exit(1);
                        }
                        fputs($fp, $description);
                        fclose($fp);
                        return true;
                        break;

                        case 'off':
                        @unlink($filename);
                        return true;
                        break;
                }

        }

}

?>
