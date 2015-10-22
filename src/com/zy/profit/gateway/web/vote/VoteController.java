package com.zy.profit.gateway.web.vote;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.collections.CollectionUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.zy.common.entity.PageModel;
import com.zy.common.entity.ResultDto;
import com.zy.member.entity.Member;
import com.zy.profit.gateway.util.HttpUtils;
import com.zy.util.AddressUtils;
import com.zy.util.RandomValidateCode;
import com.zy.vote.dto.VoteTopicDto;
import com.zy.vote.entity.VoteMemberLog;
import com.zy.vote.entity.VotePostPraise;
import com.zy.vote.entity.VotePostReport;
import com.zy.vote.entity.VoteReplayPraise;
import com.zy.vote.entity.VoteReplayReport;
import com.zy.vote.entity.VoteTopic;
import com.zy.vote.entity.VoteTopicOption;
import com.zy.vote.entity.VoteTopicPost;
import com.zy.vote.entity.VoteTopicPostReplay;
import com.zy.vote.service.VoteMemberLogService;
import com.zy.vote.service.VotePostPraiseService;
import com.zy.vote.service.VotePostReportService;
import com.zy.vote.service.VoteReplayPraiseService;
import com.zy.vote.service.VoteReplayReportService;
import com.zy.vote.service.VoteTopicOptionService;
import com.zy.vote.service.VoteTopicPostReplayService;
import com.zy.vote.service.VoteTopicPostService;
import com.zy.vote.service.VoteTopicService;

@Controller
@RequestMapping("/vote")
public class VoteController {

	@Autowired
	private VoteTopicService voteTopicService;
	@Autowired
	private VoteTopicOptionService voteTopicOptionService;
	@Autowired
	private VoteTopicPostService voteTopicPostService;
	@Autowired
	private VoteTopicPostReplayService voteTopicPostReplayService;
	@Autowired
	private VoteMemberLogService voteMemberLogService;
	@Autowired
	private VotePostPraiseService votePostPraiseService;
	@Autowired
	private VotePostReportService votePostReportService;
	@Autowired
	private VoteReplayPraiseService voteReplayPraiseService;
	@Autowired
	private VoteReplayReportService voteReplayReportService;
	
	
	@RequestMapping("/link")
	public String link(Model model, HttpServletRequest request, PageModel<VoteTopicPost> pageModel){
		
		int currentUserPostNumb = 0;
		List<VoteTopicPost> currentUserPosts = new ArrayList<VoteTopicPost>();
		
		VoteTopic currentTopic = voteTopicService.get(request.getParameter("id"));
		if(HttpUtils.getMember(request) != null){
			currentUserPosts = voteTopicPostService.findMemberPost(currentTopic.getId(), 
					HttpUtils.getMember(request).getId());
			if(CollectionUtils.isNotEmpty(currentUserPosts))
				currentUserPostNumb = currentUserPosts.size();
		}
		//判断是否在可以投票的时间
		if(currentTopic.getStartDate().after(new Date()) || currentTopic.getEndDate().before(new Date())){
			currentTopic.setIsVoteTime(false);
		}
		model.addAttribute("currentTopic", currentTopic);
		
		VoteTopicPost queryDto = new VoteTopicPost();
		queryDto.setDeleteFlag(VoteTopicPost.DELETE_FLAG_NORMAL);
		queryDto.setOrderByParam(VoteTopicPost.CREATE_DATE_PROPERTY_NAME);
		queryDto.setVoteTopic(currentTopic);
		model.addAttribute("page", voteTopicPostService.queryPage(queryDto, pageModel));

		VoteTopicDto topicQuery = new VoteTopicDto();
		topicQuery.setPageSize(4);
		topicQuery.setDeleteFlag(VoteTopicPost.DELETE_FLAG_NORMAL);
		topicQuery.setToDateEnd(new Date());
		model.addAttribute("historyTopics", voteTopicService.queryPage(topicQuery).getList());
		
		model.addAttribute("memberLogin", HttpUtils.getMember(request));
		model.addAttribute("currentUserPosts", currentUserPosts);
		model.addAttribute("currentUserPostNumb", currentUserPostNumb);
		
		
		return "vote/votePage"; 
	}
	
	@RequestMapping("/randomValidate")
	@ResponseBody
	public ResultDto<Object> randomValidate(HttpServletRequest request){
		ResultDto<Object> result = new ResultDto<Object>();
		try {
			String sessionImgCode = (String)request.getSession().getAttribute(RandomValidateCode.RANDOMCODEKEY);
			String randomCode = request.getParameter("randomCode");
			if(randomCode.equalsIgnoreCase(sessionImgCode)){
				return result;
			}else{
				result.setSuccess(false);
				result.setCode(VoteTopicDto.RESULT_CODE_RANDOMCODE_ERROR);
				return result;
			}
		} catch (Exception e) {
			e.printStackTrace();
			result.setSuccess(false);
		}
		return result;
	}
	
	@RequestMapping("/index/list")
	public String index(Model model, HttpServletRequest request,
			VoteTopicPost queryDto, PageModel<VoteTopicPost> pageModel){
		
		int currentUserPostNumb = 0;
		List<VoteTopicPost> currentUserPosts = new ArrayList<VoteTopicPost>();
		
		VoteTopic currentTopic = voteTopicService.getCurrentTopic();
		if(HttpUtils.getMember(request) != null){
			currentUserPosts = voteTopicPostService.findMemberPost(currentTopic.getId(), 
					HttpUtils.getMember(request).getId());
			if(CollectionUtils.isNotEmpty(currentUserPosts))
				currentUserPostNumb = currentUserPosts.size();
		}
		model.addAttribute("currentTopic", voteTopicService.getCurrentTopic());

		
		queryDto.setVoteTopic(currentTopic);
		queryDto.setDeleteFlag(VoteTopicPost.DELETE_FLAG_NORMAL);
		queryDto.setOrderByParam(VoteTopicPost.CREATE_DATE_PROPERTY_NAME);
		model.addAttribute("page", voteTopicPostService.queryPage(queryDto, pageModel));
		
		VoteTopicDto topicQuery = new VoteTopicDto();
		topicQuery.setPageSize(4);
		topicQuery.setDeleteFlag(VoteTopicPost.DELETE_FLAG_NORMAL);
		topicQuery.setToDateEnd(new Date());
		model.addAttribute("historyTopics", voteTopicService.queryPage(topicQuery).getList());
		
		model.addAttribute("memberLogin", HttpUtils.getMember(request));
		model.addAttribute("currentUserPosts", currentUserPosts);
		model.addAttribute("currentUserPostNumb", currentUserPostNumb);
		
		return "vote/votePage";
	}
	
	@RequestMapping("/doVote")
	@ResponseBody
	public ResultDto<VoteTopic> doVote(VoteTopicOption dto, HttpServletRequest request){
		ResultDto<VoteTopic> result = new ResultDto<VoteTopic>();
		try {
			int logNumb = voteMemberLogService.findTopicLogByIp(dto.getVoteTopic().getId(), AddressUtils.getIp(request));
			if(logNumb>0){
				result.setSuccess(false);
				result.setCode(VoteTopicDto.RESULT_CODE_VOTE_ERROR);
				return result;
			}
			
			VoteMemberLog voteLog = new VoteMemberLog();
			voteLog.setVoteTopic(dto.getVoteTopic());
			voteLog.setVoteTopicOption(dto);
			voteLog.setMember(HttpUtils.getMember(request));
			voteLog.setIpAddress(AddressUtils.getIp(request));
			voteMemberLogService.save(voteLog);
			
			VoteTopicOption optionEntity = voteTopicOptionService.get(dto.getId());
			optionEntity.setVoteCount(optionEntity.getVoteCount()+1);
			voteTopicOptionService.update(optionEntity);
			
			VoteTopic topicEntity = voteTopicService.get(dto.getVoteTopic().getId());
			topicEntity.setVoteCount(topicEntity.getVoteCount()+1);
			voteTopicService.update(topicEntity);
		} catch (Exception e) {
			e.printStackTrace();
			result.setSuccess(false);
		}
		return result;
	}
	
	@RequestMapping("/doReplayPraise")
	@ResponseBody
	public ResultDto<Object> postPraise(VoteTopicPostReplay dto, HttpServletRequest request){
		ResultDto<Object> result = new ResultDto<Object>();
		try {
			Member member = HttpUtils.getMember(request);
			if(member == null){
				result.setSuccess(false);
				result.setCode(VoteTopicDto.RESULT_CODE_LOGIN_ERROR);//用户未登录
				return result;
			}
			
			int numb = voteReplayPraiseService.findMemberPraise(dto.getId(), member.getId());
			if(numb>0){
				result.setSuccess(false);
				result.setCode(VoteTopicDto.RESULT_CODE_PRAISE_ERROR);//该帖子用户已经点赞
				return result;
			}
			
			VoteReplayPraise praise = new VoteReplayPraise();
			praise.setVoteTopicPostReplay(dto);
			praise.setMember(member);
			praise.setIpAddress(AddressUtils.getIp(request));
			voteReplayPraiseService.save(praise);
			
			VoteTopicPostReplay entity = voteTopicPostReplayService.get(dto.getId());
			entity.setPraiseCount(entity.getPraiseCount()+1);
			voteTopicPostReplayService.update(entity);
			
			result.setMessage(entity.getPraiseCount()+"");
		} catch (Exception e) {
			e.printStackTrace();
			result.setSuccess(false);
		}
		return result;
	}
	
	@RequestMapping("/doReplayReport")
	@ResponseBody
	public ResultDto<Object> postReport(VoteTopicPostReplay dto, HttpServletRequest request){
		ResultDto<Object> result = new ResultDto<Object>();
		try {
			Member member = HttpUtils.getMember(request);
			if(member == null){
				result.setSuccess(false);
				result.setCode(VoteTopicDto.RESULT_CODE_LOGIN_ERROR);//用户未登录
				return result;
			}

			int numb = voteReplayReportService.findMemberReport(dto.getId(), member.getId());
			if(numb>0){
				result.setSuccess(false);
				result.setCode(VoteTopicDto.RESULT_CODE_PRAISE_ERROR);//该回复用户已经举报
				return result;
			}
			
			VoteReplayReport report = new VoteReplayReport();
			report.setVoteTopicPostReplay(dto);
			report.setMember(member);
			report.setIpAddress(AddressUtils.getIp(request));
			voteReplayReportService.save(report);
			
			VoteTopicPostReplay entity = voteTopicPostReplayService.get(dto.getId());
			entity.setReportCount(entity.getPraiseCount()+1);
			voteTopicPostReplayService.update(entity);
			
			result.setMessage(entity.getReportCount()+"");
		} catch (Exception e) {
			e.printStackTrace();
			result.setSuccess(false);
		}
		return result;
	}
	
	@RequestMapping("/doPraise")
	@ResponseBody
	public ResultDto<VoteTopicPost> praise(VoteTopicPost dto, HttpServletRequest request){
		ResultDto<VoteTopicPost> result = new ResultDto<VoteTopicPost>();
		try {
			Member member = HttpUtils.getMember(request);
			if(member == null){
				result.setSuccess(false);
				result.setCode(VoteTopicDto.RESULT_CODE_LOGIN_ERROR);//用户未登录
				return result;
			}
			
			int memberPostNumb = votePostPraiseService.findMemberPraise(member.getId(), dto.getId());
			if(memberPostNumb>0){
				result.setSuccess(false);
				result.setCode(VoteTopicDto.RESULT_CODE_PRAISE_ERROR);//该帖子用户已经点赞
				return result;
			}
			
			VotePostPraise praise = new VotePostPraise();
			praise.setVoteTopicPost(dto);
			praise.setMember(member);
			praise.setIpAddress(AddressUtils.getIp(request));
			votePostPraiseService.save(praise);
			
			VoteTopicPost postEntity = voteTopicPostService.get(dto.getId());
			postEntity.setPraiseCount(postEntity.getPraiseCount()+1);
			voteTopicPostService.update(postEntity);
			
			result.setMessage(postEntity.getPraiseCount()+"");
			
		} catch (Exception e) {
			e.printStackTrace();
			result.setSuccess(false);
		}
		return result;
	}
	
	@RequestMapping("/doReport")
	@ResponseBody
	public ResultDto<VoteTopicPost> report(VoteTopicPost dto, HttpServletRequest request){
		ResultDto<VoteTopicPost> result = new ResultDto<VoteTopicPost>();
		try {
			Member member = HttpUtils.getMember(request);
			if(member == null){
				result.setSuccess(false);
				result.setCode(VoteTopicDto.RESULT_CODE_LOGIN_ERROR);//用户未登录
				return result;
			}
			
			int memberPostNumb = votePostPraiseService.findMemberPraise(member.getId(), dto.getId());
			if(memberPostNumb>0){
				result.setSuccess(false);
				result.setCode(VoteTopicDto.RESULT_CODE_REPORT_ERROR);//该帖子用户已经举报
				return result;
			}
			
			VotePostReport report = new VotePostReport();
			report.setVoteTopicPost(dto);
			report.setMember(member);
			report.setIpAddress(AddressUtils.getIp(request));
			votePostReportService.save(report);
			
			VoteTopicPost postEntity = voteTopicPostService.get(dto.getId());
			postEntity.setReportCount(postEntity.getReportCount()+1);
			voteTopicPostService.update(postEntity);
			
			result.setMessage(postEntity.getReportCount()+"");
		} catch (Exception e) {
			e.printStackTrace();
			result.setSuccess(false);
		}
		return result;
	}
	
	@RequestMapping("/doPost")
	@ResponseBody
	public ResultDto<VoteTopicPost> post(VoteTopicPost dto, HttpServletRequest request){
		ResultDto<VoteTopicPost> result = new ResultDto<VoteTopicPost>();
		try {
			VoteTopic topic = voteTopicService.get(dto.getVoteTopic().getId());
			
			//投票未开启投票功能
			if(!topic.getIsComment()){
				result.setSuccess(false);
				result.setCode(VoteTopicDto.RESULT_CODE_VOTE_PERMIT_ERROR);
				return result;
			}
			
			dto.setPublisher(HttpUtils.getMember(request));
			dto.setPraiseCount(0);
			dto.setReportCount(0);
			dto.setFloorNumb(topic.getPostCount()+1);
			dto.setIpAddress(AddressUtils.getIp(request));
			voteTopicPostService.save(dto);
			
			topic.setPostCount(topic.getPostCount()+1);
			voteTopicService.save(topic);
			
		} catch (Exception e) {
			e.printStackTrace();
			result.setSuccess(false);
		}
		return result;
	}
	
	@RequestMapping("/doReplay")
	@ResponseBody
	public ResultDto<VoteTopicPostReplay> raplay(VoteTopicPostReplay dto, HttpServletRequest request){
		ResultDto<VoteTopicPostReplay> result = new ResultDto<VoteTopicPostReplay>();
		try {
			Member member = HttpUtils.getMember(request);
			if(member == null){
				result.setSuccess(false);
				result.setCode(VoteTopicDto.RESULT_CODE_LOGIN_ERROR);//用户未登录
				return result;
			}
			
			dto.setReplayer(HttpUtils.getMember(request));
			dto.setIpAddress(AddressUtils.getIp(request));
			voteTopicPostReplayService.save(dto);
		} catch (Exception e) {
			e.printStackTrace();
			result.setSuccess(false);
		}
		return result;
	}
	
	@RequestMapping("/replayDialog")
	public String replayDialog(){
		
		return "vote/replayDialog";
	}
}
