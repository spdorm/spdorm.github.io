package com.rmuti.spdorm.controller;

import com.rmuti.spdorm.config.Config;
import com.rmuti.spdorm.model.bean.APIResponse;
import com.rmuti.spdorm.model.service.FixAddRepository;
import com.rmuti.spdorm.model.service.FixImageRepository;
import com.rmuti.spdorm.model.table.FixAdd;
import com.rmuti.spdorm.model.table.FixImage;
import org.apache.commons.io.FilenameUtils;
import org.apache.commons.io.IOUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

@RestController
@RequestMapping("/fixImages")
public class FixImageController {

    @Autowired
    private FixImageRepository fixImageRepository;

    @Autowired
    private FixAddRepository fixAddRepository;

    @PostMapping(value = "/saveImage")
    public Object saveImage(@RequestParam(name = "file", required = false) MultipartFile file, @RequestParam int fixId, @RequestParam int index) throws IOException {
//        log.debug("save image api");

        APIResponse res = new APIResponse();
        FixAdd fixAdd_check = fixAddRepository.findByFixId(fixId);

        LocalDateTime myDateObj = LocalDateTime.now();
        DateTimeFormatter myFormatObj = DateTimeFormatter.ofPattern("dd-MM-yyyy");
        String formattedDate = myDateObj.format(myFormatObj);

        FixImage image_db;

        if (!file.isEmpty() && fixAdd_check != null) {
            image_db = new FixImage();
            String typeName = FilenameUtils.getExtension(file.getOriginalFilename());
            String newName = index + "ID" + fixId + "_" + formattedDate + "." + typeName;
            String floder = Config.DATA_PATH_FIXIMAGES;
            Path path = Paths.get(floder + newName);
//            log.debug("path : " + path);
            //File fileContent = new File(fileName);
            //BufferedOutputStream buf = new BufferedOutputStream(new FileOutputStream(fileContent));
            byte[] bytes = file.getBytes();
            Files.write(path, bytes);
            image_db.setFixId(fixId);
            image_db.setImageName(newName);
            fixImageRepository.save(image_db);
            res.setStatus(0);
            res.setMessage("อัพรูปเรียบร้อยแล้ว");
            res.setData(image_db);

        }
//        log.debug("end save image api");
        return res;
    }

    @ResponseBody
    @RequestMapping(value = "/image", method = RequestMethod.GET, produces = MediaType.MULTIPART_FORM_DATA_VALUE)
    public byte[] getResource(@RequestParam String nameImage) throws Exception {
//        log.debug("image api");
        try {
            String path = Config.DATA_PATH_FIXIMAGES + nameImage;
            InputStream in = new FileInputStream(path);
            return IOUtils.toByteArray(in);
        } catch (Exception e) {
        }
        return null;
    }

    @PostMapping(value = "/getNameImages")
    public Object getNameImages(@RequestParam int fixId) {
        APIResponse res = new APIResponse();
        List<FixImage> image_db = fixImageRepository.findAllByFixId(fixId);
        if (image_db != null && !image_db.isEmpty()) {
            res.setStatus(0);
            res.setMessage("พบรูป");
            res.setData(image_db);
        } else {
            res.setStatus(1);
            res.setMessage("ไม่พบรูป");
        }
        return res;
    }

//    @PostMapping("/deleteByDormId")
//    public Object DeleteByDormId(@RequestParam int dormId) {
//        APIResponse res = new APIResponse();
//        List<Image> images_db = imageRepository.findAllByDormId(dormId);
//
//        if (images_db != null) {
//            res.setStatus(0);
//            imageRepository.deleteByDormId(dormId);
//            res.setMessage("ลบเรียบร้อยแล้ว");
//        } else {
//            res.setStatus(1);
//            res.setMessage("ไม่สามารถลบข้อมูลได้");
//        }
//        return res;
//    }
}
