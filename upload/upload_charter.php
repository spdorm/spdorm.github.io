<?php
include 'conn.php';

	$filename = $_FILES["image"]["name"];
	$room_id = $_POST["roomId"];
	$room_no = $_POST["roomNo"];
	$username = $_POST["username"];
	$file_basename = substr($filename, 0, strripos($filename, '.')); // get file extention
	$file_ext = substr($filename, strripos($filename, '.')); // get file name
	$filesize = $_FILES["image"]["size"];
	$allowed_file_types = array('.jpg','.png');	


	if (in_array($file_ext,$allowed_file_types) && ($filesize < 20000000))
	{	
		// Rename file
		$newfilename = $username."_".$room_id."_".$room_no."_".date('dmYHis') . $file_ext;
		if (file_exists("image/charter/" . $newfilename))
		{
			// file already exists error
			echo "You have already uploaded this file.";
		}
		else
		{		
			move_uploaded_file($_FILES["image"]["tmp_name"], "image/charter/" . $newfilename);
			echo "File uploaded successfully.";		
			$sql = "UPDATE `room_profile` 
					SET `room_document`='".$newfilename."'";
			$sql.= "WHERE `room_id` = ".$room_id."";
			mysqli_query($mysqli, $sql);
		}
	}
	elseif (empty($file_basename))
	{	
		// file selection error
		echo "Please select a file to upload.";
	} 
	elseif ($filesize > 20000000)
	{	
		// file size error
		echo "The file you are trying to upload is too large.";
	}
	else
	{
		// file type error
		echo "Only these file typs are allowed for upload: " . implode(', ',$allowed_file_types);
		unlink($_FILES["image"]["tmp_name"]);
	}
?>