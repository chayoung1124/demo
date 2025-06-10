package com.example.demo.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.example.demo.model.MemVo;
import com.example.demo.service.MemService;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/member")
@CrossOrigin("*")
public class MemController {

	@Autowired
	private MemService s;

	@Value("${google.client.id}")
	private String googleClientId;

	@PostMapping("/googleLogin")
	@ResponseBody
	public String googleLogin(HttpSession session,
			@RequestParam("google_token") String googleToken) {
		GoogleIdToken.Payload payload = s.verifyGoogleToken(googleToken);

		if (payload != null) {
			System.out.println("✅ 구글 토큰 검증 성공!");
			System.out.println("📧 Email: " + payload.getEmail());
			System.out.println("👤 Name: " + payload.get("name"));
			System.out.println("🆔 Subject: " + payload.getSubject());
			System.out.println("🌐 Issuer: " + payload.getIssuer());
			System.out.println("🔐 Audience: " + payload.getAudience());

			String email = payload.getEmail();
			String name = (String) payload.get("name");
			String sub = payload.getSubject();

			MemVo vo = s.selectGoogle(sub);
			if (vo != null) {
				session.setAttribute("member_id", vo.getMember_id());
				session.setAttribute("member_name", vo.getMember_name());
				
				return "success:" + vo.getMember_id();
			} else {
				MemVo mem = new MemVo();
				mem.setMember_id(sub);
				mem.setMember_name(name);
				mem.setMember_email(email);
				mem.setLogin_type("google");

				s.insertGoogle(mem);
				session.setAttribute("member_id", sub);
				session.setAttribute("member_name", name);
				
				return "success:" + sub;
			}
		}
		System.out.println("❌ 구글 토큰 검증 실패!");
		
		return "fail";
	}

	@GetMapping("")
	public String index(Model model, HttpSession session) {
		String memberId = (String) session.getAttribute("member_id");

		if (memberId != null) {
			MemVo vo = s.selectMemId(memberId);
			model.addAttribute("member", vo);

			List<MemVo> list = s.selectMembers();
			model.addAttribute("memberList", list);

			return "index";
		}
		return "redirect:/member/login";
	}

	@GetMapping("/memview")
	public String memberView(Model model, HttpSession session,
			@RequestParam("member_id") String memberId) {
		String sessionId = (String) session.getAttribute("member_id");
		System.out.println((String) session.getAttribute("member_name"));
		
		if (!memberId.equals(sessionId)) {
			session.removeAttribute("member_id");
			return "redirect:login";
		}
		
		MemVo vo = s.selectMemId(memberId);
		model.addAttribute("memberView", vo);
		model.addAttribute("memberName", vo.getMember_name());
		return "memview";
	}

	@GetMapping("/count")
	public String count(Model model,
			@RequestParam("member_id") String memberId) {
		MemVo vo = s.getCount(memberId);
		model.addAttribute("count", vo);
		
		return "count";
	}

	@GetMapping("/memwrite")
	public String memwrite() {
		return "memwrite";
	}

	@PostMapping("/memwrite")
	public String memwrite(MemVo vo) {
		s.insertMember(vo);
		System.out.println(vo);
		
		return "redirect:/member/login";
	}

	@GetMapping("/memupdate")
	public String memupdate(Model model,
			@RequestParam("member_id") String memberId) {
		MemVo vo = s.selectMemId(memberId);
		model.addAttribute("member", vo);
		model.addAttribute("memberName", vo.getMember_name());
		
		return "memupdate";
	}

	@PostMapping("/memupdate")
	public String memupdate(MemVo mem,
			@RequestParam("member_id") String memberId) {
		MemVo vo = s.selectMemId(memberId);
		vo.setMember_id(mem.getMember_id());
		vo.setMember_pwd(mem.getMember_pwd());
		vo.setMember_name(mem.getMember_name());
		vo.setMember_phone(mem.getMember_phone());
		vo.setMember_type(mem.getMember_type());
		vo.setPostal_addr(mem.getPostal_addr());
		vo.setRoad_addr(mem.getRoad_addr());
		vo.setStreet_addr(mem.getStreet_addr());
		vo.setDetail_addr(mem.getDetail_addr());
		
		s.updateMember(vo);

		return "redirect:/member/memview?member_id=" + memberId;
	}

	@GetMapping("/memdelete")
	public String memdelete(@RequestParam("member_no") int memberNo) {
		s.deleteMember(memberNo);
		
		return "redirect:/member";
	}

	@PostMapping("/list")
	@ResponseBody
	public List<MemVo> getMemberList() {
		return s.selectMembers();
	}

	@GetMapping("/login")
	public String login(Model model, HttpSession session) {
		String memberId = (String) session.getAttribute("member_id");
		if (memberId != null) {
			return "redirect:/member/memview";
		}
		return "login";
	}

	@PostMapping("/login")
	public String login(HttpSession session, RedirectAttributes re,
			@RequestParam("member_id") String memberId,
			@RequestParam("member_pwd") String memberPwd) {

		try {
			String memId = s.memLogin(memberId, memberPwd);
			if (memId == null) {
				re.addFlashAttribute("error", "이름,비번다시입력");
				return "redirect:/member/login";
			}
			
			session.setAttribute("member_id", memId);
			session.setAttribute("member_name", s.selectMemId(memberId).getMember_name());
			
			return "redirect:/member/memview?member_id=" + memberId;
		} catch (Exception e) {
			e.printStackTrace();
			re.addFlashAttribute("error", "오류남");
			
			return "redirect:/member/login";
		}
	}

	@PostMapping("/logout")
	public String logout(HttpSession session) {
		session.invalidate();
		return "redirect:/member/login";
	}
	
	@GetMapping("/idcheck")
	@ResponseBody
	public String checkId(@RequestParam("member_id") String memberId) {
		boolean isAvailable = s.IdAvailable(memberId);
		return isAvailable ? "available":"duplicate";
	}
}