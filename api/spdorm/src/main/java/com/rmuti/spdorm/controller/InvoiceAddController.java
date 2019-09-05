package com.rmuti.spdorm.controller;

import com.rmuti.spdorm.model.bean.APIResponse;
import com.rmuti.spdorm.model.service.InvoiceAddRepository;
import com.rmuti.spdorm.model.table.InvoiceAdd;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/invoice")

public class InvoiceAddController {

    @Autowired
    private InvoiceAddRepository invoiceAddRepository;

    @PostMapping("/add")
    public Object add(InvoiceAdd invoiceAdd) {
        APIResponse res = new APIResponse();
        InvoiceAdd invoiceAddDb = invoiceAddRepository.findByInvoiceId(invoiceAdd.getInvoiceId());
        if (invoiceAddDb == null) {
            res.setStatus(0);
            res.setMessage("บันทึกข้อมูลเรียบร้อยแล้ว");
            invoiceAddRepository.save(invoiceAdd);
        } else {
            res.setStatus(1);
            res.setMessage("มีข้อมูลชุดนี้อยู่แล้ว");
        }
        return res;
    }

    @PostMapping("/list")
    public Object list(@RequestParam int dormId, @RequestParam int userId, @RequestParam int roomId) {
        APIResponse res = new APIResponse();
        List<Object[]> invoiceAdd_db = invoiceAddRepository.findByDormIdAndUserIdAndRoomId(dormId, userId, roomId);
        if(invoiceAdd_db!=null && !invoiceAdd_db.isEmpty()){
            res.setStatus(0);
            res.setMessage("พบข้อมูล");
            res.setData(invoiceAddRepository.findByDormIdAndUserIdAndRoomId(dormId, userId, roomId));
        }else {
            res.setStatus(1);
            res.setMessage("ไม่พบข้อมูล");
        }
        return res;
    }

    @PostMapping("/updateStatus")
    public Object updateStatus(@RequestParam int invoiceId,@RequestParam String status){
        APIResponse res = new APIResponse();
        InvoiceAdd invoiceAdd_db = invoiceAddRepository.findByInvoiceId(invoiceId);
        if(invoiceAdd_db != null){
            res.setStatus(0);
            res.setMessage("แก้ไขสถานะใบแจ้งชำระแล้ว");
            invoiceAddRepository.updateInvoice(invoiceId, status);
        }else{
            res.setStatus(1);
            res.setMessage("ไม่พบข้อมูล");
        }
        return res;
    }

    @PostMapping("/deleteInvoice")
    public Object deleteInvoice(@RequestParam int invoiceId){
        APIResponse res = new APIResponse();
        InvoiceAdd invoiceAdd_db = invoiceAddRepository.findByInvoiceId(invoiceId);
        if(invoiceAdd_db != null){
            res.setStatus(0);
            res.setMessage("ลบใบแจ้งชำระแล้ว");
            invoiceAddRepository.deleteById(invoiceId);
        }else{
            res.setStatus(1);
            res.setMessage("ไม่พบข้อมูล");
        }
        return res;
    }

}
