<?php
// connect.php
$db_config=array(
    "host"=>"localhost",  // กำหนด host
    "user"=>"root", // กำหนดชื่อ user
    "pass"=>"12345",   // กำหนดรหัสผ่าน
    "dbname"=>"spdorm_db",  // กำหนดชื่อฐานข้อมูล
    "charset"=>"utf8"  // กำหนด charset
);
$mysqli = @new mysqli($db_config["host"], $db_config["user"], $db_config["pass"], $db_config["dbname"]);
if(mysqli_connect_error()) {
	echo "Connected";
    die('Connect Error (' . mysqli_connect_errno() . ') '. mysqli_connect_error());
    exit;
}
if(!$mysqli->set_charset($db_config["charset"])) { // เปลี่ยน charset เป้น utf8 พร้อมตรวจสอบการเปลี่ยน
//    printf("Error loading character set utf8: %sn", $mysqli->error);  // ถ้าเปลี่ยนไม่ได้
	echo "Connected";
}else{
//    printf("Current character set: %sn", $mysqli->character_set_name()); // ถ้าเปลี่ยนได้
}
//echo $mysqli->character_set_name();  // แสดง charset เอา comment ออก
//echo 'Success... ' . $mysqli->host_info . "n";
//$mysqli->close();
?>