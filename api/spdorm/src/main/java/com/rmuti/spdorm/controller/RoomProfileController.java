package com.rmuti.spdorm.controller;

import com.rmuti.spdorm.model.bean.APIResponse;
import com.rmuti.spdorm.model.service.RoomProfileRepository;
import com.rmuti.spdorm.model.service.UserProfileRepository;
import com.rmuti.spdorm.model.table.RoomProfile;
import com.rmuti.spdorm.model.table.UserProfile;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/room")

public class RoomProfileController {

    @Autowired
    private RoomProfileRepository roomProfileRepository;

    @Autowired
    private UserProfileRepository userProfileRepository;

    @PostMapping("/add")
    public Object register(RoomProfile roomProfile) {
        APIResponse res = new APIResponse();
        RoomProfile roomProfileDb = roomProfileRepository.findByRoomId(roomProfile.getRoomId());
        if (roomProfileDb == null) {
            res.setStatus(0);
            res.setMessage("เพิ่มห้องเรียบร้อยแล้ว");
            roomProfileRepository.save(roomProfile);
        } else {
            res.setStatus(1);
            res.setMessage("id ห้องซ้ำ!");
        }
        return res;
    }

    @PostMapping("/countStatus")
    public Object countStatus(@RequestParam int dormId){
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
    public Object listRoom(@RequestParam int dormId, @RequestParam int roomId){
        APIResponse res = new APIResponse();
        RoomProfile roomProfileDb = roomProfileRepository.findRoomByDormIdAndRoomId(dormId,roomId);
        if (roomProfileDb != null) {
            res.setStatus(0);
            res.setMessage("พบข้อมูล");
            res.setData(roomProfileRepository.findRoomByDormIdAndRoomId(dormId,roomId));
        } else {
            res.setStatus(1);
            res.setMessage("ไม่พบข้อมูล");
        }
        return res;
    }

    @PostMapping("/updateRoom")
    public Object updateRoom(@RequestParam String status,@RequestParam String type,@RequestParam String floor,@RequestParam String no,@RequestParam String price,@RequestParam String doc,@RequestParam int roomId){
        APIResponse res = new APIResponse();
        roomProfileRepository.updateRoom(status,type,floor,no,price,doc,roomId);
        res.setStatus(0);
        res.setMessage("สำเร็จ");
        return res;
    }

    @PostMapping("/deleteRoom")
    public Object deleteRoom(RoomProfile roomProfile){
        APIResponse res = new APIResponse();
        RoomProfile roomProfile1_db = roomProfileRepository.findByRoomId(roomProfile.getRoomId());
        if(roomProfile1_db != null){
            res.setStatus(0);
            roomProfileRepository.delete(roomProfile);
            res.setMessage("ลบสำเร็จ");
        }else {
            res.setStatus(1);
            res.setMessage("ลบไม่สำเร็จ");
        }
        return res;
    }

    @PostMapping("/listFloor")
    public Object listFloor(
                       @RequestParam int dormId,
                       @RequestParam int roomFloor
                       ){
        APIResponse res = new APIResponse();
        res.setData(roomProfileRepository.listByDormIdAndFloor(dormId, roomFloor));
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
    public Object addCustomerToRoom(@RequestParam int roomId,@RequestParam String userName){
        APIResponse res = new APIResponse();
        UserProfile userProfile_db = userProfileRepository.findByUserUsername(userName);
        RoomProfile roomProfile_db = roomProfileRepository.findByRoomId(roomId);
        if(roomProfile_db != null && userProfile_db != null){
            res.setStatus(0);
            roomProfileRepository.updateCustomerToRoom(roomId,userProfile_db.getUserId(),"ไม่ว่าง");
            res.setMessage("เพิ่มผู้เช่าเรียบร้อยแล้ว");
        }else {
            res.setStatus(1);
            res.setMessage("ไม่พบห้องนี้");
        }
        return res;
    }

    @PostMapping("/findByCustomerId")
    public Object findByCustomerId(@RequestParam int userId){
        APIResponse res =new APIResponse();
        RoomProfile roomProfile_db = roomProfileRepository.findByCustomerId(userId);
        if(roomProfile_db != null){
            res.setStatus(0);
            res.setData(roomProfile_db);
            res.setMessage("พบข้อมูลผู้เช่าห้อง");
        }else {
            res.setStatus(1);
            res.setMessage("ไม่พบข้อมูลผู้เช่าห้อง");
        }
        return res;
    }
}
