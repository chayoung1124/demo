package com.example.demo.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.example.demo.filter.RequestWrapper;
import com.example.demo.model.BoardVo;
import com.example.demo.model.MemVo;
import com.example.demo.model.ReVo;
import com.example.demo.service.BoardService;
import com.example.demo.service.ReService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/board")
public class BoardController {

	@Autowired
	private BoardService s;
	@Autowired
	private ReService r;

	@GetMapping("")
	public String boardList(Model model, HttpSession session, BoardVo vo) {
		List<BoardVo> list = s.selectBoards();
		model.addAttribute("boardList", list);
		
		model.addAttribute("board", vo);
		
		return "board";
	}

	@GetMapping("/view")
	public String boardView(Model model, HttpSession session,
			@RequestParam("board_no") int boardNo) {
		BoardVo vo = s.selectView(boardNo);

		if (vo == null) {
			return "redirect:/board";
		}

		if (vo.getOpen_yn() == 0) {
			Object pass = session.getAttribute("pw_pass_" + boardNo);
			if (pass == null || !Boolean.TRUE.equals(pass)) {
				return "passwordCheck";
			}
		}

		System.out.println("file name:" + vo.getFile_name());
		model.addAttribute("boardView", vo);

		List<ReVo> relist = r.selectContent(boardNo);
		model.addAttribute("replyList", relist);

		String memberId = (String) session.getAttribute("member_id");

		if (memberId == null) {
			return "redirect:/member/login";
		}

		MemVo mem = s.getMemId(memberId);
		model.addAttribute("memberName", mem.getMember_name());
		model.addAttribute("board", vo);
		
		return "view";
	}

	@GetMapping("/write")
	public String write(Model model, HttpSession session) {
		String memberId = (String) session.getAttribute("member_id");

		if (memberId == null) {
			System.out.println("🚨 memberId is null!");
			return "redirect:/member/login";
		}

		System.out.println("🔍 Fetching user with memberId: " + memberId);
		
		MemVo mem = s.getMemId(memberId);

		if (mem == null) {
			System.out.println("❌ selectMemId() returned null for memberId: " + memberId);
			return "redirect:/error";
		}

		model.addAttribute("memberName", mem.getMember_name());
		model.addAttribute("memberId", mem.getMember_id());
		
		return "write";
	}
	
	
	@PostMapping("/write")
	public String write(BoardVo vo, Model model, HttpSession session,
						HttpServletRequest request, HttpServletResponse response, RedirectAttributes re,
						@RequestParam(value="file", required=false) MultipartFile file,
						@RequestParam(value="image", required=false) MultipartFile image,						
						@RequestParam(value="noticeCheck", required=false) String noticeCheck) throws IOException{
		String loginUser = (String) session.getAttribute("member_id");
		
		if(loginUser == null) {
			return "redirect:/login";
		}
		
		if(request instanceof RequestWrapper) {
	        RequestWrapper req = (RequestWrapper) request;
	        if(req.isXssDetected()) {
	            re.addFlashAttribute("xssmsg", "XSS 공격이 감지되었습니다. 다시 작성해주세요.");
	            return "redirect:/board/write";
	        }
	    }
		
		vo.setBoard_writer(loginUser);
		
		if("1".equals(noticeCheck)) {
			int noticeCount = s.getNoticeCount();
			if(noticeCount >= 5) {
				re.addFlashAttribute("ntcmsg", "공지는 최대 5개까지 등록할 수 있습니다");
				return "redirect:/board/write";
			}
			vo.setNotice_no(1);
		} else {
			vo.setNotice_no(0);
		}
		
		if(file != null && !file.isEmpty()) {
			String savedFileName = storeFile(file);
			vo.setFile_name(savedFileName);
			
			Date createDate = new Date();
			String year = new SimpleDateFormat("yyyy").format(createDate);
			String month = new SimpleDateFormat("MM").format(createDate);
			String day = new SimpleDateFormat("dd").format(createDate);
			vo.setFile_path(year + "/" + month + "/" + day);
		}

		if(image != null && !image.isEmpty()) {
			String savedImageName = storeImage(image);
			vo.setImage_name(savedImageName);
			
			Date createDate = new Date();
			String year = new SimpleDateFormat("yyyy").format(createDate);
			String month = new SimpleDateFormat("MM").format(createDate);
			String day = new SimpleDateFormat("dd").format(createDate);
			vo.setImage_path(year + "/" + month + "/" + day);
		}
		
		if(vo.getOpen_yn() == 0 && (vo.getBoard_pw() == null || vo.getBoard_pw().length() != 4)) {
			re.addFlashAttribute("pwmsg", "비밀번호를 확인해주세요");
			return "redirect:/board/write";
		}
		
		s.insertBoard(vo);
		
		return "redirect:/board";
	}
	
	@GetMapping("/update")
	public String update(Model model, HttpSession session,
			@RequestParam("board_no") int boardNo) {
		BoardVo vo = s.selectView(boardNo);
		if(vo == null) {
			return "redirect:/board";
		}
		
		String memberId = (String) session.getAttribute("member_id");
		if(memberId == null || !vo.getBoard_writer().equals(memberId)) {
			return "redirect:/board";
		}
		
		MemVo mem = s.getMemId(memberId);
		model.addAttribute("memberName", mem.getMember_name());
		model.addAttribute("board", vo);
		
		return "update";
	}

	@PostMapping("/update")
	public String update(BoardVo board, HttpSession session, HttpServletRequest request, RedirectAttributes re,
			@RequestParam("board_no") int boardNo,
			@RequestParam(value = "uploadFile", required = false) MultipartFile file,
			@RequestParam(value = "origin_file_name", required = false) String originFile,
			@RequestParam(value = "delete_file", required = false) String deleteFile,
			@RequestParam(value = "uploadImage", required = false) MultipartFile image,
			@RequestParam(value = "origin_image_name", required = false) String originImage,
			@RequestParam(value = "delete_image", required = false) String deleteImage,
			@RequestParam(value = "image_name", required = false) String imageName,
			@RequestParam(value = "image_path", required = false) String imagePath) {

		BoardVo vo = s.selectView(boardNo);
		String loginUser = (String) session.getAttribute("member_id");

		if (vo == null || loginUser == null || !vo.getBoard_writer().equals(loginUser)) {
			return "redirect:/board";
		}

		vo.setBoard_title(board.getBoard_title());
		vo.setBoard_date(board.getBoard_date());
		vo.setBoard_content(board.getBoard_content());
		
		if(request instanceof RequestWrapper) {
	        RequestWrapper req = (RequestWrapper) request;
	        if(req.isXssDetected()) {
	            re.addFlashAttribute("xssmsg", "XSS 공격이 감지되었습니다. 다시 작성해주세요.");
	            return "redirect:/board/update";
	        }
	    }

		if (file != null && !file.isEmpty()) {
			String newFileName = storeFile(file);
			vo.setFile_name(newFileName);
			
			Date createDate = new Date();
			String year = new SimpleDateFormat("yyyy").format(createDate);
			String month = new SimpleDateFormat("MM").format(createDate);
			String day = new SimpleDateFormat("dd").format(createDate);
			
			vo.setFile_path(year + "/" + month + "/" + day);
		} else if ("true".equals(deleteFile)) {
			vo.setFile_name(null);
			vo.setFile_path(null);
		} else {
			vo.setFile_name(originFile);
		}
		
		if(image != null && !image.isEmpty()) {
			String newImageName = storeImage(image);
			vo.setImage_name(newImageName);
			
			Date createDate = new Date();
			String year = new SimpleDateFormat("yyyy").format(createDate);
			String month = new SimpleDateFormat("MM").format(createDate);
			String day = new SimpleDateFormat("dd").format(createDate);
			
			vo.setImage_path(year+"/"+month+"/"+day);
		} else if("true".equals(deleteImage)) {
			vo.setImage_name(null);
			vo.setImage_path(null);
		} else if(imageName != null && imagePath != null) {
			vo.setImage_name(imageName);
			vo.setImage_path(imagePath);
		} else {
			vo.setImage_name(originImage);
		}

		s.updateBoard(vo);

		return "redirect:/board/view?board_no=" + boardNo;
	}

	@GetMapping("/delete")
	public String delete(HttpSession session,
			@RequestParam("board_no") int boardNo) {
		BoardVo vo = s.selectView(boardNo);
		String loginUser = (String) session.getAttribute("member_id");

		if (vo == null || loginUser == null || !vo.getBoard_writer().equals(loginUser)) {
			return "redirect:/board";
		}

		s.deleteBoard(boardNo);
		
		return "redirect:/board";
	}

	@GetMapping("/list")
	public String board(Model model) {
		return "list";
	}

	@PostMapping("/list")
	@ResponseBody
	public List<BoardVo> getBoardList() {
		return s.selectBoards();
	}

	@PostMapping("/checkPassword")
	@ResponseBody
	public Map<String, Object> checkPassword(HttpSession session,
			@RequestParam("board_no") int boardNo,
			@RequestParam("password") String password) {
		BoardVo vo = s.selectView(boardNo);
		boolean match = vo != null && password.equals(vo.getBoard_pw());

		if (match) {
			session.setAttribute("pw_pass_" + boardNo, true);
		}

		Map<String, Object> response = new HashMap<>();
		response.put("success", match);
		
		return response;
	}

	@Value("${file.upload-dir}")
	private String uploadDir;
	
	@Value("${image.upload-dir}")
	private String imageDir;

	@Transactional(rollbackFor = Exception.class)
	public String storeFile(MultipartFile file) {
		Date createDate = new Date();
		String year = (new SimpleDateFormat("yyyy").format(createDate));
		String month = (new SimpleDateFormat("MM").format(createDate));
		String day = (new SimpleDateFormat("dd").format(createDate));

		Path directory = Paths.get(uploadDir, year, month, day);

		String fileName = file.getOriginalFilename();
		String saveFileName = uuidFileName(fileName);

		try {
			Files.createDirectories(directory);
			Path targetPath = directory.resolve(saveFileName).normalize();
			
			if (Files.exists(targetPath)) {
				throw new IOException("중복된 파일이 있어서 실패함");
			}
			file.transferTo(targetPath);
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		return saveFileName;
	}
	
	@Transactional(rollbackFor = Exception.class)
	public String storeImage(MultipartFile image) {
		Date createDate = new Date();
		String year = (new SimpleDateFormat("yyyy").format(createDate));
		String month = (new SimpleDateFormat("MM").format(createDate));
		String day = (new SimpleDateFormat("dd").format(createDate));

		Path directory = Paths.get(imageDir, year, month, day);

		String imageName = image.getOriginalFilename();
		String saveImageName = uuidFileName(imageName);

		try {
			Files.createDirectories(directory);
			Path targetPath = directory.resolve(saveImageName).normalize();
			
			if (Files.exists(targetPath)) {
				throw new IOException("중복된 파일이 있어서 실패함");
			}
			image.transferTo(targetPath);
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		return saveImageName;
	}
	
	@PostMapping("/uploadImage")
	@ResponseBody
	public Map<String, Object> uploadImage(@RequestParam("image") MultipartFile image) {
	    Map<String, Object> response = new HashMap<>();
	    try {
	        String savedImageName = storeImage(image);
	        Date createDate = new Date();
	        String year = new SimpleDateFormat("yyyy").format(createDate);
	        String month = new SimpleDateFormat("MM").format(createDate);
	        String day = new SimpleDateFormat("dd").format(createDate);
	        String imagePath = year + "/" + month + "/" + day;

	        response.put("success", 1);
	        response.put("file", Map.of("url", "/demo/image/" + imagePath + "/" + savedImageName,
	        							"name", savedImageName,
	        							"path", imagePath ));
	    } catch (Exception e) {
	        e.printStackTrace();
	        response.put("success", 0);
	        response.put("message", "이미지 업로드 실패: 서버 오류");
	    }
	    return response;
	}


	private String uuidFileName(String originalFileName) {
		UUID uuid = UUID.randomUUID();
		return uuid.toString() + "_" + originalFileName;
	}

	@GetMapping("/file/download")
	public void downloadFile(HttpServletResponse response,
			@RequestParam("fileName") String fileName,
			@RequestParam("filePath") String filePath) {
		try {
			String decodedFileName = java.net.URLDecoder.decode(fileName, "UTF-8");
			String decodedFilePath = java.net.URLDecoder.decode(filePath, "UTF-8");

			Path filePathObj = Paths.get(uploadDir, decodedFilePath, decodedFileName).normalize();
			File file = filePathObj.toFile();

			if (!file.exists()) {
				response.setStatus(HttpServletResponse.SC_NOT_FOUND);
				return;
			}

			try (FileInputStream fis = new FileInputStream(file); OutputStream os = response.getOutputStream()) {
				String originalFileName = decodedFileName.substring(decodedFileName.indexOf("_") + 1);
				String encodedDownloadName = java.net.URLEncoder.encode(originalFileName, "UTF-8").replaceAll("\\+", "%20");

				response.setContentType(org.springframework.http.MediaType.APPLICATION_OCTET_STREAM_VALUE);
				response.setHeader("Content-Disposition", "attachment; filename*=UTF-8''" + encodedDownloadName);
				response.setContentLength((int) file.length());

				FileCopyUtils.copy(fis, os);
				os.flush();
			}
		} catch (IOException e) {
			e.printStackTrace();
			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
		}
	}
	
	@GetMapping("/file/downloadImage")
	public void downloadImage(HttpServletResponse response,
			@RequestParam("imageName") String imageName,
			@RequestParam("imagePath") String imagePath) {
		try {
			String decodedImageName = java.net.URLDecoder.decode(imageName, "UTF-8");
			String decodedImagePath = java.net.URLDecoder.decode(imagePath, "UTF-8");

			Path filePathObj = Paths.get(imageDir, decodedImagePath, decodedImageName).normalize();
			File file = filePathObj.toFile();

			if (!file.exists()) {
				response.setStatus(HttpServletResponse.SC_NOT_FOUND);
				return;
			}

			try (FileInputStream fis = new FileInputStream(file);
				 OutputStream os = response.getOutputStream()) {
				
				String originalFileName = decodedImageName.substring(decodedImageName.indexOf("_") + 1);
				String encodedDownloadName = java.net.URLEncoder.encode(originalFileName, "UTF-8").replaceAll("\\+", "%20");
	
				response.setContentType(org.springframework.http.MediaType.APPLICATION_OCTET_STREAM_VALUE);
				response.setHeader("Content-Disposition", "attachment; filename*=UTF-8''" + encodedDownloadName);
				response.setContentLength((int) file.length());
	
				FileCopyUtils.copy(fis, os);
				os.flush();
			}
		} catch (IOException e) {
			e.printStackTrace();
			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
		}
	}
	
	@GetMapping("/image/{year}/{month}/{day}/{imageName}")
	@ResponseBody
	public void serveImage(HttpServletResponse response,
			@PathVariable String year,
			@PathVariable String month,
			@PathVariable String day,
			@PathVariable String imageName) {
		try {
			Path imagePath = Paths.get(imageDir, year, month, day, imageName);
			File imageFile = imagePath.toFile();
			
			if(!imageFile.exists()) {
				response.setStatus(HttpServletResponse.SC_NOT_FOUND);
				return;
			}
			
			String contentType = Files.probeContentType(imagePath);
			response.setContentType(contentType != null ? contentType : "/image/jpeg");
			
			try (FileInputStream fis = new FileInputStream(imageFile);
					OutputStream os = response.getOutputStream()){
				FileCopyUtils.copy(fis, os);
			}
		} catch(IOException e) {
			e.printStackTrace();
			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
		}
	}
}