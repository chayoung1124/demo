//package com.example.demo.controller;
//
//import java.io.IOException;
//import java.nio.file.Files;
//import java.nio.file.Path;
//import java.nio.file.Paths;
//import java.text.SimpleDateFormat;
//import java.util.Date;
//import java.util.UUID;
//
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.http.MediaType;
//import org.springframework.web.bind.annotation.GetMapping;
//import org.springframework.web.bind.annotation.PostMapping;
//import org.springframework.web.bind.annotation.RequestMapping;
//import org.springframework.web.bind.annotation.RequestParam;
//import org.springframework.web.bind.annotation.RestController;
//import org.springframework.web.multipart.MultipartFile;
//
//import com.example.demo.service.BoardService;
//
//@RestController
//@RequestMapping("/tui-editor")
//public class FileController {
//
//	@Autowired
//	private BoardService s;
//
//	private final String uploadDir = Paths.get("C:", "upload", "image").toString();
//
//	@PostMapping("/image-upload")
//	public String uploadImage(@RequestParam final MultipartFile image) {
//		if (image.isEmpty()) {
//			return "";
//		}
//
//		try {
//			Date createDate = new Date();
//			String year = new SimpleDateFormat("yyyy").format(createDate);
//			String month = new SimpleDateFormat("MM").format(createDate);
//			String day = new SimpleDateFormat("dd").format(createDate);
//
//			Path datePath = Paths.get(uploadDir, year, month, day);
//
//			Files.createDirectories(datePath);
//
//			String originFilename = image.getOriginalFilename();
//			String uuid = UUID.randomUUID().toString().replaceAll("-", "");
//			String extension = originFilename.substring(originFilename.lastIndexOf(".") + 1);
//			String saveFilename = uuid + "." + extension;
//
//			Path fileFullPath = datePath.resolve(saveFilename);
//
//			image.transferTo(fileFullPath.toFile());
//
//			String dbPath = Paths.get(year, month, day, saveFilename).toString().replace("\\", "/");
//
//			return dbPath;
//
//		} catch (IOException e) {
//			throw new RuntimeException("파일 업로드 실패", e);
//		}
//	}
//
//	@GetMapping(value = "/image-print", produces = {
//			MediaType.IMAGE_GIF_VALUE,
//			MediaType.IMAGE_JPEG_VALUE,
//			MediaType.IMAGE_PNG_VALUE })
//	public byte[] printImage(@RequestParam final String filename) {
//		try {
//			Path filePath = Paths.get(uploadDir, filename);
//
//			if (!Files.exists(filePath)) {
//				throw new RuntimeException("파일이 존재하지않음" + filename);
//			}
//			return Files.readAllBytes(filePath);
//		} catch (IOException e) {
//			throw new RuntimeException("파일 읽기 실패", e);
//		}
//	}
//}
