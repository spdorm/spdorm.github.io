package com.rmuti.spdorm.controller;

import java.time.LocalDateTime;
import java.util.List;

import com.rmuti.spdorm.model.bean.APIResponse;
import com.rmuti.spdorm.model.service.FixAddRepository;
import com.rmuti.spdorm.model.table.FixAdd;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/fix")

public class FixAddController {

    @Autowired
    private FixAddRepository fixAddRepository;

    @PostMapping("/add")
    public Object add(FixAdd fixAdd) {
        APIResponse res = new APIResponse();
        fixAdd.setEndDateTime(null);
        res.setStatus(0);
        res.setMessage("แจ้งซ่อมเรียบร้อยแล้ว");
        fixAddRepository.save(fixAdd);
        res.setData(fixAdd.getFixId());
        return res;
    }

    @PostMapping("/listAll")
    public Object listAll(@RequestParam int dormId) {
        APIResponse res = new APIResponse();
        List<FixAdd> fixAdd_db = fixAddRepository.listByDormId(dormId);
        if (fixAdd_db != null) {
            res.setStatus(0);
            res.setMessage("พบข้อมูล");
            res.setData(fixAddRepository.listByDormId(dormId));
        } else {
            res.setStatus(1);
            res.setMessage("ไม่พบข้อมูล");
        }
        return res;
    }

    @PostMapping("/findByFixId")
    public Object findByFixId(@RequestParam int fixId) {
        APIResponse res = new APIResponse();
        FixAdd fixAdd_check = fixAddRepository.findByFixIdOrderByFixIdDesc(fixId);

        if (fixAdd_check != null) {
            res.setStatus(0);
            res.setMessage("พบข้อมูล");
            res.setData(fixAdd_check);
        } else {
            res.setStatus(1);
            res.setMessage("ไม่พบข้อมูล");
        }
        return res;
    }

    @PostMapping("/listForRoom")
    public Object listForRoom(@RequestParam int dormId, @RequestParam int roomId) {
        APIResponse res = new APIResponse();
        FixAdd fixAdd_db = fixAddRepository.findByDormId(dormId);
        if (fixAdd_db != null) {
            res.setStatus(0);
            res.setMessage("พบข้อมูล");
            res.setData(fixAddRepository.listByDormIdAndRoomId(dormId, roomId));
        } else {
            res.setStatus(1);
            res.setMessage("ไม่พบข้อมูล");
        }
        return res;
    }

    @PostMapping("/updateStatus")
    public Object updateStatus(@RequestParam int fixId, @RequestParam String status) {
        APIResponse res = new APIResponse();
        FixAdd fixAdd_db = fixAddRepository.findByFixId(fixId);

        LocalDateTime myDateObj = LocalDateTime.now();

        if (fixAdd_db != null) {
            res.setStatus(0);
            res.setMessage("อัพเดทสถานะเรียบร้อยแล้ว");
            fixAddRepository.updateStatus(fixId, status, status.equals("success") ? myDateObj.toString() : null);
        } else {
            res.setStatus(1);
            res.setMessage("ไม่พบการแจ้งช่อมนี้");
        }
        return res;
    }

    @PostMapping("/updateFixNoteAndFixPrice")
    public Object updateFixNoteAndFixPrice(@RequestParam int fixId, @RequestParam(required = false) String fixNote, @RequestParam(required = false) int fixPrice) {
        APIResponse res = new APIResponse();
        FixAdd fixAdd_check = fixAddRepository.findByFixId(fixId);

        if (fixAdd_check != null) {
            fixAdd_check.setFixNote(!fixNote.isEmpty() ? fixNote : "");
            fixAdd_check.setFixPrice(fixPrice != 0 ? fixPrice : 0);
            fixAddRepository.save(fixAdd_check);
            res.setStatus(0);
            res.setMessage("แก้ไขหมายเหตุและราคาแล้ว");
        } else {
            res.setStatus(1);
            res.setMessage("ไม่พบข้อมูล");
        }
        return res;
    }

}
