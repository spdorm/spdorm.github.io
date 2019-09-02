package com.rmuti.spdorm.controller;

import com.rmuti.spdorm.model.bean.APIResponse;
import com.rmuti.spdorm.model.service.DormProfileRepository;
import com.rmuti.spdorm.model.table.DormProfile;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.*;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import org.apache.commons.io.IOUtils;

@RestController
@RequestMapping("/dorm")

public class DormProfileController {

    @Autowired
    private DormProfileRepository dormProfileRepository;

    private String pathUpload = FolderUpload.gcp_dorm;

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

    @PostMapping("/saveImage")
    public Object saveImage(@RequestParam(name = "file", required = false) MultipartFile file, @RequestParam int dormId) throws IOException {
        APIResponse res = new APIResponse();
        LocalDateTime myDateObj = LocalDateTime.now();
        DateTimeFormatter myFormatObj = DateTimeFormatter.ofPattern("dd-MM-yyyy_HHmmss");
        String formattedDate = myDateObj.format(myFormatObj);

        DormProfile dormProfile_db = dormProfileRepository.findByDormId(dormId);

        if (!file.isEmpty() && dormProfile_db != null) {
            String fileName = file.getOriginalFilename();
            String typeName = file.getOriginalFilename().substring(fileName.length() - 3);
            String newName = formattedDate + "." + typeName;
            Path path = Paths.get(pathUpload + newName);
            //File fileContent = new File(fileName);
            //BufferedOutputStream buf = new BufferedOutputStream(new FileOutputStream(fileContent));
            byte[] bytes = file.getBytes();
            Files.write(path, bytes);
            dormProfileRepository.updateDormImage(dormId, newName);
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
            String path = pathUpload + nameImage;
            InputStream in = new FileInputStream(path);
            return IOUtils.toByteArray(in);
        } catch (Exception e) {
        }
        return null;
    }
}
