package com.rmuti.spdorm.controller;

import com.rmuti.spdorm.model.bean.APIResponse;
import com.rmuti.spdorm.model.service.DormProfileRepository;
import com.rmuti.spdorm.model.service.RoomProfileRepository;
import com.rmuti.spdorm.model.service.UserProfileRepository;
import com.rmuti.spdorm.model.table.DormProfile;
import com.rmuti.spdorm.model.table.RoomProfile;
import com.rmuti.spdorm.model.table.UserProfile;
import org.apache.commons.io.IOUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

@RestController
@RequestMapping("/room")

public class RoomProfileController {

    @Autowired
    private RoomProfileRepository roomProfileRepository;

    @Autowired
    private DormProfileRepository dormProfileRepository;

    @Autowired
    private UserProfileRepository userProfileRepository;

    @PostMapping("/add")
    public Object register(RoomProfile roomProfile) {
        APIResponse res = new APIResponse();
        RoomProfile roomProfileDb = roomProfileRepository.findRoomByDormIdAndRoomNo(roomProfile.getDormId(), roomProfile.getRoomNo());
        if (roomProfileDb == null) {
            res.setStatus(0);
            res.setMessage("เพิ่มห้องเรียบร้อยแล้ว");
            roomProfileRepository.save(roomProfile);
        } else {
            res.setStatus(1);
            res.setMessage("หมายเลขหรือข้อมูลห้องนี้ซ้ำ!");
        }
        return res;
    }

    @PostMapping("/countStatus")
    public Object countStatus(@RequestParam int dormId) {
        APIResponse res = new APIResponse();
        res.setData(roomProfileRepository.countByDormId(dormId));
        return res;
    }

//    @PostMapping("/addRent")
//    public Object addRent(@RequestParam int dormId,@RequestParam String roomNo,@RequestParam String userName,@RequestParam String doc){
//        APIResponse res = new APIResponse();
//        RoomProfile roomProfile_db = roomProfileRepository.findRoomByDormIdAndRoomNo(dormId,roomNo);
//        UserProfile userProfile_db = userProfileRepository.findByUserUsername(userName);
//        if(roomProfile_db != null && userProfile_db != null){
//            res.setStatus(0);
//            res.setMessage("เพิ่มสัญญาเช่าเรียบร้อยแล้ว");
//        }
//        return res;
//    }

    @PostMapping("/listRoom")
    public Object listRoom(@RequestParam int dormId, @RequestParam int roomId) {
        APIResponse res = new APIResponse();
        RoomProfile roomProfileDb = roomProfileRepository.findRoomByDormIdAndRoomId(dormId, roomId);
        if (roomProfileDb != null) {
            res.setStatus(0);
            res.setMessage("พบข้อมูล");
            res.setData(roomProfileRepository.findRoomByDormIdAndRoomId(dormId, roomId));
        } else {
            res.setStatus(1);
            res.setMessage("ไม่พบข้อมูล");
        }
        return res;
    }

    @PostMapping("/updateRoom")
    public Object updateRoom(@RequestParam String status, @RequestParam String type, @RequestParam String floor, @RequestParam String no, @RequestParam String price, @RequestParam String doc, @RequestParam int roomId) {
        APIResponse res = new APIResponse();
        roomProfileRepository.updateRoom(status, type, floor, no, price, doc, roomId);
        res.setStatus(0);
        res.setMessage("สำเร็จ");
        return res;
    }

    @PostMapping("/deleteRoom")
    public Object deleteRoom(RoomProfile roomProfile) {
        APIResponse res = new APIResponse();
        RoomProfile roomProfile1_db = roomProfileRepository.findByRoomId(roomProfile.getRoomId());
        if (roomProfile1_db != null) {
            res.setStatus(0);
            roomProfileRepository.delete(roomProfile);
            res.setMessage("ลบสำเร็จ");
        } else {
            res.setStatus(1);
            res.setMessage("ลบไม่สำเร็จ");
        }
        return res;
    }

    @PostMapping("/listFloor")
    public Object listFloor(
            @RequestParam int dormId,
            @RequestParam int roomFloor
    ) {
        APIResponse res = new APIResponse();
        DormProfile dormProfile_db = dormProfileRepository.findByDormId(dormId);
        if (dormProfile_db != null) {
            res.setStatus(0);
            res.setMessage("พบข้อมูล");
            res.setData(roomProfileRepository.listByDormIdAndFloor(dormId, roomFloor));
        } else {
            res.setStatus(1);
            res.setMessage("ไม่พบข้อมูล");
        }
        return res;
    }

    // @PostMapping("/checkRoomAndUser")
    // public Object checkRoomAndUser(
    //                 @RequestParam int dormId,
    //                 @RequestParam int userId,
    //                 @RequestParam String roomNo,
    //                 @RequestParam String userUserName
    // ){
    //     APIResponse res = new APIResponse();
    //     List temp = roomProfileRepository.findRoomByDormIdAndUserIdAndRoomNo(dormId, userId, roomNo, userUserName);
    //     if(temp.isEmpty()){
    //         res.setStatus(1);
    //         res.setMessage("ไม่พบข้อมูล");
    //     }else {
    //         res.setStatus(0);
    //         res.setMessage("พบข้อมูล");
    //     }
    //     return res;
    // }

    @PostMapping("/updateCustomerToRoom")
    public Object addCustomerToRoom(@RequestParam int roomId, @RequestParam String userName) {
        APIResponse res = new APIResponse();
        UserProfile userProfile_db = userProfileRepository.findByUserUsername(userName);
        RoomProfile roomProfile_db = roomProfileRepository.findByRoomId(roomId);
        RoomProfile checkCustomer = roomProfileRepository.findByCustomerId(userProfile_db.getUserId());
        if (roomProfile_db != null && userProfile_db != null) {
            if (checkCustomer == null) {
                res.setStatus(0);
                roomProfileRepository.updateCustomerToRoom(roomId, userProfile_db.getUserId(), "ไม่ว่าง");
                res.setMessage("เพิ่มผู้เช่าเรียบร้อยแล้ว");
            } else {
                res.setStatus(1);
                res.setMessage("รหัสผู้ใช้นี้มีข้อมูลเช่าห้องอื่นอยู่แล้ว");
            }
        } else {
            res.setStatus(1);
            res.setMessage("ไม่พบห้องหรือรหัสผู้ใช้นี้");
        }
        return res;
    }

    @PostMapping("/cancelRent")
    public Object cancelRent(@RequestParam int roomId) {
        APIResponse res = new APIResponse();
        RoomProfile roomProfile_db = roomProfileRepository.findByRoomId(roomId);
        if (roomProfile_db != null) {
            res.setStatus(0);
            roomProfileRepository.updateCustomerToRoom(roomId, 0, "ว่าง");
            res.setMessage("ยกเลิกสัญญาเช่าเรียบร้อยแล้ว");
        } else {
            res.setData(1);
            res.setMessage("ไม่พบข้อมูลสัญญาเช่า");
        }
        return res;
    }


    @PostMapping("/findByCustomerId")
    public Object findByCustomerId(@RequestParam int userId) {
        APIResponse res = new APIResponse();
        RoomProfile roomProfile_db = roomProfileRepository.findByCustomerId(userId);
        if (roomProfile_db != null) {
            res.setStatus(0);
            res.setData(roomProfile_db);
            res.setMessage("พบข้อมูลผู้เช่าห้อง");
        } else {
            res.setStatus(1);
            res.setMessage("ไม่พบข้อมูลผู้เช่าห้อง");
        }
        return res;
    }

    @PostMapping("/saveImage")
    public Object saveImage(@RequestParam(name = "file", required = false) MultipartFile file, @RequestParam int roomId, @RequestParam int roomNo, @RequestParam String userName) throws IOException {
        APIResponse res = new APIResponse();
        LocalDateTime myDateObj = LocalDateTime.now();
        DateTimeFormatter myFormatObj = DateTimeFormatter.ofPattern("dd-MM-yyyy_HHmmss");
        String formattedDate = myDateObj.format(myFormatObj);

        RoomProfile roomProfile_db = roomProfileRepository.findByRoomId(roomId);

        if (!file.isEmpty() && roomProfile_db != null) {
            String fileName = file.getOriginalFilename();
            String typeName = file.getOriginalFilename().substring(fileName.length() - 3);
            String newName = roomNo + "_" + userName + "_" + formattedDate + "." + typeName;
            String floder = "/home/nicapa_sr/spdorm/images/charter/";
            Path path = Paths.get(floder + newName);
            //File fileContent = new File(fileName);
            //BufferedOutputStream buf = new BufferedOutputStream(new FileOutputStream(fileContent));
            byte[] bytes = file.getBytes();
            Files.write(path, bytes);
            roomProfileRepository.updateImageToRoom(roomId,newName);
            res.setStatus(0);
            res.setMessage("อัพรูปเรียบร้อยแล้ว");
            res.setData(newName);
        }
        return res;
    }

    @ResponseBody
    @RequestMapping(value = "/image", method = RequestMethod.GET, produces = MediaType.IMAGE_JPEG_VALUE)
    public byte[] getResource(@RequestParam String nameImage) throws Exception {
        try {
            String path = "/home/nicapa_sr/spdorm/images/charter/" + nameImage;
            InputStream in = new FileInputStream(path);
            return IOUtils.toByteArray(in);
        } catch (Exception e) {
        }
        return null;
    }
}
