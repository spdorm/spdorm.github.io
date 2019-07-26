package com.rmuti.spdorm.controller;

import com.rmuti.spdorm.model.bean.APIResponse;
import com.rmuti.spdorm.model.service.AddNewsRepository;
import com.rmuti.spdorm.model.table.AddNews;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/News")

public class AddNewsController {

    @Autowired
    private AddNewsRepository addNewsRepository;

    @PostMapping("/add")
    public Object add(AddNews addNews) {
        APIResponse res = new APIResponse();
        AddNews addNewsDb = addNewsRepository.findByNewsTopic(addNews.getNewsTopic());
        if (addNewsDb == null) {
            res.setStatus(0);
            res.setMessage("เพิ่มข่าวสารเรียบร้อยแล้ว");
            addNewsRepository.save(addNews);
        } else {
            res.setStatus(1);
            res.setMessage("หัวข้อข่าวซ้ำ !");
        }
        return res;
    }

    @PostMapping("/list")
    public Object list(@RequestParam int dormId){
        APIResponse res = new APIResponse();
        res.setData(addNewsRepository.findByDormId(dormId));
        return res;
    }

}
