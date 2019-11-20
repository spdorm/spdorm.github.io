package com.rmuti.spdorm.controller;

import com.rmuti.spdorm.model.bean.APIResponse;
import com.rmuti.spdorm.model.service.PaymentRepository;
import com.rmuti.spdorm.model.table.Payment;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/payment")
public class PaymentController {
    @Autowired
    private PaymentRepository paymentRepository;

    @PostMapping("/add")
    public Object add(Payment payment) {
        APIResponse res = new APIResponse();
        paymentRepository.save(payment);
        return res;
    }

    @PostMapping("/list")
    public Object list(@RequestParam int dormId, @RequestParam int userId) {
        APIResponse res = new APIResponse();
        List<Payment> payment_Db = paymentRepository.findByDormIdAndUserId(dormId, userId);
        if (payment_Db != null && !payment_Db.isEmpty()) {
            res.setStatus(0);
            res.setData(payment_Db);
            res.setMessage("พบข้อมูล");
        } else {
            res.setStatus(1);
            res.setMessage("ไม่พบข้อมูล");
        }
        return res;
    }

    @PostMapping("/sumAmount")
    public Object sumAmount(@RequestParam int dormId, @RequestParam int userId) {
        APIResponse res = new APIResponse();
        Object payment_db = paymentRepository.sumAmount(dormId, userId);

        if (payment_db != null) {
            res.setStatus(0);
            res.setMessage("พบข้อมูล");
            res.setData(payment_db);
        } else {
            res.setStatus(1);
            res.setMessage("ไม่พบข้อมูล");
        }
        return res;
    }

}
