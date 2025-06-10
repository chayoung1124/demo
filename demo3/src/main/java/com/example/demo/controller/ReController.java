package com.example.demo.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.demo.model.BoardVo;
import com.example.demo.model.MemVo;
import com.example.demo.model.ReVo;
import com.example.demo.service.BoardService;
import com.example.demo.service.ReService;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/reply")
public class ReController {

	@Autowired
	private ReService s;
	@Autowired
	private BoardService b;

	@GetMapping("")
	public String replyList(Model model) {
		List<ReVo> list = s.selectReplys();
		model.addAttribute("replyList", list);
		
		return "reply";
	}

	@GetMapping("/review")
	public String replyView(Model model, HttpSession session,
			@RequestParam("reply_no") int replyNo) {
		ReVo vo = s.selectReView(replyNo);
		model.addAttribute("replyView", vo);

		String memberId = (String) session.getAttribute("member_id");
		MemVo mem = s.getMemId(memberId);
		model.addAttribute("memberName", mem.getMember_name());
		
		return "review";
	}

	@GetMapping("/rewrite")
	public String rewrite(Model model, HttpSession session,
			@RequestParam("board_no") int boardNo) {
		String memberId = (String) session.getAttribute("member_id");
		BoardVo vo = b.selectView(boardNo);
		MemVo mem = s.getMemId(memberId);
		
		model.addAttribute("board", vo);
		model.addAttribute("memberName", mem.getMember_name());
		
		return "rewrite";
	}

	@PostMapping("/rewrite")
	public String rewrite(ReVo vo,
			@RequestParam("board_no") int boardNo) {
		s.insertReply(vo);
		System.out.println(vo);
		
		return "redirect:/board/view?board_no=" + boardNo;
	}

	@GetMapping("/reupdate")
	public String reupdate(Model model, HttpSession session,
			@RequestParam("reply_no") int replyNo,
			@RequestParam("board_no") int boardNo) {
		ReVo vo = s.selectReView(replyNo);
		if (vo == null) {
			return "redirect:/board/view?board_no=" + boardNo;
		}

		model.addAttribute("reply", vo);
		model.addAttribute("boardNo", boardNo);

		return "reupdate";
	}

	@PostMapping("/reupdate")
	@ResponseBody
	public ResponseEntity<String> reupdate(ReVo re,
			@RequestParam("reply_no") int replyNo,
			@RequestParam("reply_content") String replyContent,
			@RequestParam("board_no") int boardNo) {
		ReVo vo = s.selectReView(replyNo);
		if (vo == null) {
			return ResponseEntity.status(HttpStatus.NOT_FOUND).body("댓글 없음");
		}

		vo.setReply_writer(re.getReply_writer());
		vo.setReply_content(re.getReply_content());
		vo.setReply_date(re.getReply_date());
		s.updateReply(vo);

		return ResponseEntity.ok("success");
	}

	@PostMapping("/reupdateAjax")
	@ResponseBody
	public String updateReplyAjax(ReVo vo,
			@RequestParam("reply_no") int reply_no,
			@RequestParam("reply_content") String reply_content,
			@RequestParam("board_no") int board_no) {
		vo.setReply_no(reply_no);
		vo.setReply_content(reply_content);

		s.updateReply(vo);

		return "success";
	}

	@GetMapping("/redelete")
	public String redelete(
			@RequestParam("reply_no") int replyNo,
			@RequestParam("board_no") int boardNo) {
		s.deleteReply(replyNo);
		
		return "redirect:/board/view?board_no=" + boardNo;
	}

	@PostMapping("/list")
	@ResponseBody
	public List<ReVo> getReplyList() {
		return s.selectReplys();
	}

}