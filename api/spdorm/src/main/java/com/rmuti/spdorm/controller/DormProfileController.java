package com.rmuti.spdorm.controller;

import com.rmuti.spdorm.model.bean.APIResponse;
import com.rmuti.spdorm.model.service.DormProfileRepository;
import com.rmuti.spdorm.model.table.DormProfile;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/dorm")

public class DormProfileController {

    @Autowired
    private DormProfileRepository dormProfileRepository;

    @PostMapping("/add")
    public Object add(DormProfile dormProfile) {
        APIResponse res = new APIResponse();
        DormProfile dormProfileDb = dormProfileRepository.findByDormAddress(dormProfile.getDormAddress());
        if (dormProfileDb == null) {
            res.setStatus(0);
            res.setMessage("เพิ่มหอพักเรียบร้อยแล้ว");
            dormProfileRepository.save(dormProfile);
            res.setData(dormProfile.getDormId());
        } else {
            res.setStatus(1);
            res.setMessage("ที่อยู่ซ้ำ!");
        }
        return res;
    }

    @PostMapping("/updateDormProfile")
    public Object updateDormProfile(@RequestParam int dormId, @RequestParam String dormName, @RequestParam String dormAddress, @RequestParam String dormTelephone, @RequestParam String dormEmail, @RequestParam String dormFloor, @RequestParam String dormPrice, @RequestParam String dormPromotion, @RequestParam String dormDetail, @RequestParam String dormStatus) {
        APIResponse res = new APIResponse();
        DormProfile dormProfile_db = dormProfileRepository.getOne(dormId);
        if (dormProfile_db != null) {
            res.setStatus(0);
            dormProfileRepository.updateDormProfile(dormId, dormName, dormAddress, dormTelephone, dormEmail, dormFloor, dormPrice, dormPromotion, dormDetail, dormStatus);
            res.setMessage("อัพเดทข้อมูลหอพักเรียบร้อยแล้ว");
        } else {
            res.setStatus(1);
            res.setMessage("ไม่พบหอพักนี้");
        }
        return res;
    }

    @PostMapping("/list")
    public Object list(@RequestParam int dormId) {
        APIResponse res = new APIResponse();
        res.setData(dormProfileRepository.findById(dormId));
        return res;
    }

    // Frank created 05-06-2562
    // For: List all dorm.
    @PostMapping("/listAll")
    public Object listAll() {
        APIResponse res = new APIResponse();
        if (dormProfileRepository.listall() != null) {
            res.setStatus(0);
            res.setMessage("สร้างรายการหอพักเรียบร้อยแล้ว");
            res.setData(dormProfileRepository.listall());
        } else {
            res.setStatus(1);
            res.setMessage("พบข้อผิดพลาด โปรดติดต่อผู้พัฒนาระบบ");
        }
        return res;
    }

    @PostMapping("/findInfo")
    public Object findInfo(@RequestParam int userId) {
        APIResponse res = new APIResponse();
        res.setData(dormProfileRepository.findInfo(userId));
        return res;
    }

    @PostMapping("/findImageDorm")
    public Object findImageDorm(@RequestParam int dormId) {
        APIResponse res = new APIResponse();
        String str = dormProfileRepository.findImageByDormId(dormId);
        if (str == null) {
            res.setStatus(1);
            res.setMessage("ไม่พบรูปภาพ");
        } else {
            res.setStatus(0);
            res.setMessage("พบรูปภาพ");
            res.setData(dormProfileRepository.findImageByDormId(dormId));
        }
        return res;
    }

//    @PostMapping("/updateFloor")
//    public Object updateFloor(@RequestParam int dormId,
//                              @RequestParam int userId,
//                              @RequestParam String dormFloor){
//        APIResponse res = new APIResponse();
//        DormProfile dormProfile_db = dormProfileRepository.findByDormIdAndUserId(dormId,userId);
//
//        if(dormProfile_db != null){
//            res.setData(dormProfileRepository.updateFloor(dormId, userId, dormFloor));
//            res.setStatus(0);
//            res.setMessage("อัพเดทชั้นแล้ว");
//        }else{
//            res.setStatus(1);
//            res.setMessage("ไม่อัพเดทข้อมูล");
//        }
//
//        return res;
//    }

}
