package com.rmuti.spdorm.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import com.rmuti.spdorm.model.bean.APIResponse;
import com.rmuti.spdorm.model.service.UserProfileRepository;
import com.rmuti.spdorm.model.table.UserProfile;

import java.util.Optional;

@RestController
@RequestMapping("/user")

public class UserProfileController {

    @Autowired
    private UserProfileRepository userProfileRepository;

    @PostMapping("/login")
    public Object login(@RequestParam String userUsername, @RequestParam String userPassword){
        APIResponse res = new APIResponse();
        UserProfile userProfile_db = userProfileRepository.findByUserUsernameAndUserPassword(userUsername,userPassword);
        if(userProfile_db != null) {
            res.setStatus(0);
            res.setData(userProfile_db);
            res.setMessage("เข้าสู่ระบบเรียบร้อยแล้ว");
        }else {
            res.setStatus(1);
            res.setMessage("กรอกข้อมูลไม่ถูกต้องหรือไม่มีบัญชีผู้ใช้นี้");
        }
        return res;
    }

    @PostMapping("/register")
    public Object register(UserProfile userProfile) {
        APIResponse res = new APIResponse();
        UserProfile userProfileDb = userProfileRepository.findByUserUsername(userProfile.getUserUsername());
        if (userProfileDb == null) {
            res.setStatus(0);
            res.setMessage("สมัครสมาชิกเรียบร้อยแล้ว");
            userProfileRepository.save(userProfile);
        } else {
            res.setStatus(1);
            res.setMessage("มี Username นี้อยู่แล้ว");
        }
        return res;
    }

    @PostMapping("/list")
    public Object list(@RequestParam int userId) {
        APIResponse res = new APIResponse();
        res.setData(userProfileRepository.findByUserId(userId));
        return res;
    }

    @PostMapping("/updateProfile")
    public Object updateProfile(@RequestParam int userId, @RequestParam String userFirstname, @RequestParam String userLastname, @RequestParam String userAddress, @RequestParam String userTelephone, @RequestParam String userEmail) {
        APIResponse res = new APIResponse();
        UserProfile userProfile_db = userProfileRepository.findByUserId(userId);
        if(userProfile_db != null){
            res.setStatus(0);
            userProfileRepository.updateProfile(userId,userFirstname,userLastname,userAddress,userTelephone,userEmail);
            res.setMessage("อัพเดทโปรไฟล์เรียบร้อยแล้ว");
        }else {
            res.setStatus(1);
            res.setMessage("ไม่พบบัญชีผู้ใช้");
        }
        return res;
    }


}