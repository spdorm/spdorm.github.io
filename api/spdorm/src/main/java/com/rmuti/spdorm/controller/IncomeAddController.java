package com.rmuti.spdorm.controller;

import com.rmuti.spdorm.model.bean.APIResponse;
import com.rmuti.spdorm.model.service.IncomeAddRepository;
import com.rmuti.spdorm.model.table.FixAdd;
import com.rmuti.spdorm.model.table.IncomeAdd;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/income")

public class IncomeAddController {

    @Autowired
    private IncomeAddRepository incomeAddRepository;

    @PostMapping("/add")
    public Object add(IncomeAdd incomeAdd) {
        APIResponse res = new APIResponse();
        IncomeAdd incomeAddDb = incomeAddRepository.findByIncomeId(incomeAdd.getIncomeId());
        if (incomeAddDb == null) {
            res.setStatus(0);
            res.setMessage("บันทึกข้อมูลเรียบร้อยแล้ว");
            incomeAddRepository.save(incomeAdd);
        } else {
            res.setStatus(1);
            res.setMessage("มีข้อมูลชุดนี้อยู่แล้ว");
        }
        return res;
    }

    @PostMapping("/listAll")
    public Object list(@RequestParam int dormId){
        APIResponse res = new APIResponse();
        List incomeAdd_db = incomeAddRepository.listByDormId(dormId);
        if(!incomeAdd_db.isEmpty()){
            res.setStatus(0);
            res.setData(incomeAdd_db);
            res.setMessage("พบข้อมูล");
        }else{
            res.setStatus(1);
            res.setMessage("ไม่พบข้อมูล");
        }
        return res;
    }

}
