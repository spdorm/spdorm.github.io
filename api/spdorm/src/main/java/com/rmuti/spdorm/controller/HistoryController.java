package com.rmuti.spdorm.controller;

import java.util.List;

import com.rmuti.spdorm.model.bean.APIResponse;
import com.rmuti.spdorm.model.service.DormProfileRepository;
import com.rmuti.spdorm.model.service.HistoryRepository;
import com.rmuti.spdorm.model.service.UserProfileRepository;
import com.rmuti.spdorm.model.table.DormProfile;
import com.rmuti.spdorm.model.table.History;
import com.rmuti.spdorm.model.table.UserProfile;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/history")

public class HistoryController {

    @Autowired
    private HistoryRepository historyRepository;

    @Autowired
    private UserProfileRepository userProfileRepository;

    @Autowired
    private DormProfileRepository dormProfileRepository;

    @PostMapping("/add")
    public Object add(History history) {
        APIResponse res = new APIResponse();
        UserProfile userProfile_db = userProfileRepository.findByUserId(history.getUserId());
        DormProfile dormProfile_db = dormProfileRepository.findByDormId(history.getDormId());
        if (userProfile_db != null && dormProfile_db != null) {
            res.setStatus(0);
            res.setMessage("เพิ่มข้อมูลแล้ว");
            historyRepository.save(history);
        } else {
            res.setStatus(1);
            res.setMessage("ไม่พบหอพักหรือบัญชีผู้ใช้");
        }
        return res;
    }

    @PostMapping("/listByIdAndStatus")
    public Object listAll(@RequestParam int dormId,String status){
        APIResponse res = new APIResponse();
        List<Object[]> history_db = historyRepository.listByDormId(dormId,status);
        if(history_db != null){
            res.setStatus(0);
            res.setData(history_db);
            res.setMessage("พบข้อมูล");
        }else{
            res.setStatus(1);
            res.setMessage("ไม่พบข้อมูล");
        }
        return res;
    }

    @PostMapping("/checkStatus")
    public Object checkStatus(@RequestParam int dormId,@RequestParam int userId,@RequestParam String status){
        APIResponse res = new APIResponse();
        History history_db = historyRepository.findByDormIdAndUserId(dormId,userId,status);
        if(history_db != null){
            res.setStatus(0);
            res.setMessage("พบคำขอ");
            res.setData(history_db.getHistoryStatus());
        }else{
            res.setStatus(1);
            res.setMessage("ไม่พบคำขอ");
        }
        return res;
    }

    @PostMapping("/delete")
    public Object delete(@RequestParam int dormId,@RequestParam int userId,@RequestParam String status){
        APIResponse res = new APIResponse();
        History history_db = historyRepository.findByDormIdAndUserId(dormId,userId,status);
        if(history_db != null){
            res.setStatus(0);
            res.setMessage("พบคำขอและลบเรียบร้อยแล้ว");
            historyRepository.delete(history_db);
        }else{
            res.setStatus(1);
            res.setMessage("ไม่พบคำขอ");
        }
        return res;
    }
}
