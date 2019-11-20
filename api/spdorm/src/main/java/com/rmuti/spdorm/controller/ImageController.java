package com.rmuti.spdorm.controller;

import com.rmuti.spdorm.config.Config;
import com.rmuti.spdorm.model.bean.APIResponse;
import com.rmuti.spdorm.model.service.ImageRepository;
import com.rmuti.spdorm.model.table.DormProfile;
import com.rmuti.spdorm.model.table.Image;
import lombok.extern.log4j.Log4j2;
import org.apache.commons.io.FilenameUtils;
import org.apache.commons.io.IOUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Sort;
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

@Log4j2
@RestController
@RequestMapping("/imageDetail")
public class ImageController {

    @Autowired
    private ImageRepository imageRepository;

    @PostMapping(value = "/saveImage")
    public Object saveImage(@RequestParam(name = "file", required = false) MultipartFile file, @RequestParam int dormId, @RequestParam int index) throws IOException {
        log.debug("save image api");

        APIResponse res = new APIResponse();
        LocalDateTime myDateObj = LocalDateTime.now();
        DateTimeFormatter myFormatObj = DateTimeFormatter.ofPattern("dd-MM-yyyy");
        String formattedDate = myDateObj.format(myFormatObj);

        Image image_db;

        if (!file.isEmpty()) {
            image_db = new Image();
            String typeName = FilenameUtils.getExtension(file.getOriginalFilename());
            String newName = index + "D" + dormId + "_" + formattedDate + "." + typeName;
            String floder = Config.DATA_PATH_DORM;
            Path path = Paths.get(floder + newName);
            log.debug("path : " + path);
            //File fileContent = new File(fileName);
            //BufferedOutputStream buf = new BufferedOutputStream(new FileOutputStream(fileContent));
            byte[] bytes = file.getBytes();
            Files.write(path, bytes);
            image_db.setDormId(dormId);
            image_db.setImageName(newName);
            imageRepository.save(image_db);
            res.setStatus(0);
            res.setMessage("อัพรูปเรียบร้อยแล้ว");
            res.setData(image_db);

        }
        log.debug("end save image api");
        return res;
    }

    @ResponseBody
    @RequestMapping(value = "/image", method = RequestMethod.GET, produces = MediaType.MULTIPART_FORM_DATA_VALUE)
    public byte[] getResource(@RequestParam String nameImage) throws Exception {
        log.debug("image api");
        try {
            String path = Config.DATA_PATH_DORM + nameImage;
            InputStream in = new FileInputStream(path);
            return IOUtils.toByteArray(in);
        } catch (Exception e) {
        }
        return null;
    }

    @PostMapping(value = "/getNameImages")
    public Object getNameImages(@RequestParam int dormId) {
        APIResponse res = new APIResponse();
        List<Image> image_db = imageRepository.findAllByDormId(dormId);
        res.setData(image_db);
        return res;
    }

    @PostMapping("/deleteByDormId")
    public Object DeleteByDormId(@RequestParam int dormId){
        APIResponse res = new APIResponse();
        List<Image> images_db = imageRepository.findAllByDormId(dormId);

        if(images_db != null){
            res.setStatus(0);
            imageRepository.deleteByDormId(dormId);
            res.setMessage("ลบเรียบร้อยแล้ว");
        }else {
            res.setStatus(1);
            res.setMessage("ไม่สามารถลบข้อมูลได้");
        }
        return res;
    }
}
