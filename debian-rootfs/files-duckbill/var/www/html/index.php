<?php

function get_model()
{
  $rv = "(unknown)";

  if (($handle = fopen("/etc/device_info", "r")) !== FALSE)
  {
    while (($data = fgetcsv($handle, 1000, "=", "'")) !== FALSE)
    {
      if ($data[0] == "DEVICE_PRODUCT")
        $rv = $data[1];
    }
    fclose($handle);
  }

  return $rv;
}

function get_serial()
{
  $rv = "(unknown)";

  if (($handle = fopen("/proc/cpuinfo", "r")) !== FALSE)
  {
    while (($data = fgetcsv($handle, 1000, ":")) !== FALSE)
    {
      if (trim($data[0]) == "Serial")
        $rv = trim($data[1]);
    }
    fclose($handle);
  }

  return $rv;
}

$hostname = file_get_contents("/etc/hostname");
$model = get_model();
$serial = get_serial();
$mac_address = file_get_contents("/sys/class/net/eth0/address");

?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />

  <title>Home</title>
  <link href="style.css" rel="stylesheet" type="text/css" />
</head>

<body>
  <div id="wholepage">
    <div id="logofill">
      <img src="i2se.png" />
      <h1><?php echo $model; ?></h1>
      <h2><?php echo $hostname; ?></h2>
    </div>

    <div id="wrap">
      <div id="topbar">
        <div id="menus">
          <ul id="topmenu">
            <li class="active">
              <a href="#">Home</a>
            </li>
          </ul>
        </div>
      </div>
      <div id="notifybar">&nbsp;</div>
      <div id="content">
        <div id="mainpage">

          <h3>Device information</h3>
          <table>
            <tr>
              <td>Serial&nbsp;number:</td>
              <td id="serial"><?php echo $serial; ?></td>
            </tr>
            <tr>
              <td>MAC&nbsp;address:</td>
              <td id="mac_address_host"><?php echo $mac_address; ?></td>
            </tr>
            <tr>
              <td>IP address:</td>
              <td id="ip_address"><?php echo $_SERVER['SERVER_ADDR']; ?></td>
            </tr>
          </table>

        </div>
      </div>

      <div id="footer">
        <p><a href="http://www.i2se.com/">http://www.i2se.com/</a></p>

        <p>Copyright &copy; 2016 I2SE GmbH</p>
      </div>
    </div>
  </div>
</body>
</html>
