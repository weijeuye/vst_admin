package com.lvmama.vst.back.o2o.web;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;

import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.math.NumberUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.lvmama.comm.pet.fs.client.FSClient;
import com.lvmama.vst.back.client.o2o.service.ContractRecordClientService;
import com.lvmama.vst.back.client.o2o.service.ContractRecordScanClientService;
import com.lvmama.vst.back.client.o2o.service.SubCompanyClientService;
import com.lvmama.vst.back.client.o2o.service.SubCompanySholdRelationClientService;
import com.lvmama.vst.back.o2o.po.ContractRecord;
import com.lvmama.vst.back.o2o.po.ContractRecordScan;
import com.lvmama.vst.back.o2o.po.ShareholderInfo;
import com.lvmama.vst.back.o2o.po.SubCompany;
import com.lvmama.vst.back.o2o.utils.ConstantEnums.CONTRACTSUBJECTYPE;
import com.lvmama.vst.back.o2o.utils.ConstantEnums.CONTRACTTYPE;
import com.lvmama.vst.back.supp.po.SuppContract;
import com.lvmama.vst.back.utils.Constants;
import com.lvmama.vst.comm.utils.CalendarUtils;
import com.lvmama.vst.comm.vo.Page;
import com.lvmama.vst.comm.vo.ResultMessage;
import com.lvmama.vst.comm.web.BaseActionSupport;
import com.lvmama.vst.comm.web.BusinessException;

@Controller
@RequestMapping("/o2o/subCompany")
public class ContractRecordAction extends BaseActionSupport {

    private static final long serialVersionUID = 6183910840427201633L;
    private static final Logger LOGGER = LoggerFactory.getLogger(ContractRecordAction.class);

    @Autowired
    private FSClient vstFSClient;
    @Autowired //
    private ContractRecordClientService contractRecordService;
    @Autowired
    private ContractRecordScanClientService contractRecordScanService;
    @Autowired
    private SubCompanySholdRelationClientService subCompanySholdRelationService;
    @Autowired
    private SubCompanyClientService subCompanyService;

    /**
     * 批量上传合同扫描件
     * 
     * @param
     * @return
     */
    @RequestMapping(value = "/contract/scan")
    @ResponseBody
    public Object uploadContractScan(MultipartHttpServletRequest req, Long subCompanyId, Long contractId,
            @RequestParam(value = "delIds[]", required = false) List<Long> delIds, HttpServletResponse res,
            String serverType) throws Exception {
        LOGGER.info("start method<ContractRecordAction#uploadContractScan>");
        if (LOGGER.isInfoEnabled()) {
            LOGGER.info("subCompanyId:" + subCompanyId + ";contractId:" + contractId + ";delIds:" + delIds);
        }

        if (StringUtils.isEmpty(serverType)) {
            LOGGER.error("Invalid server type.");
            return new ResultMessage(ResultMessage.ERROR, "服务类型不存在");
        }
        List<MultipartFile> tempScanList = req.getFiles("scan");
        List<ContractRecordScan> contractScanList = new ArrayList<ContractRecordScan>();
        try {
            for (MultipartFile file : tempScanList) {
                if (file.getSize() == 0) {
                    continue;
                }
                ContractRecordScan object = new ContractRecordScan();
                object.setContractId(contractId);
                uploadFile(file, serverType, object);
                contractScanList.add(object);
            }
            // 将上传好的数据文件名等保存到数据库，如果delIds存在则删除这个List中包含的数据
            contractRecordScanService.updateContractScanList(contractScanList, delIds, this.getLoginUserId(),
                    contractId, subCompanyId);
        } catch (Exception e) {
            LOGGER.error("Error occurred while uploading materials.", e);
            return new ResultMessage(ResultMessage.ERROR, "系统内部异常");
        }
        return new ResultMessage(ResultMessage.SUCCESS, "保存成功");
    }

    /**
     * 获得合同备案扫描件
     * 
     * @param model
     * @param param
     * @param req
     * @return
     * @throws BusinessException
     */
    @RequestMapping(value = "/contract/scans")
    public String findContractScanList(Model model, String param, String auditType, HttpServletRequest req)
            throws BusinessException {
        LOGGER.info("start method<ContractRecordAction#findContractScanList>");
        if (LOGGER.isInfoEnabled()) {
            LOGGER.info("param is " + param + ";auditType is " + auditType);
        }
        try {
            Map<String, Object> paramsMap = new HashMap<String, Object>();
            if (null != param && !"".equals(param)) {
                JSONObject jsonObject = JSONObject.fromObject(param);
                for (Iterator<?> iter = jsonObject.keys(); iter.hasNext();) {
                    String key = (String) iter.next();
                    String value = jsonObject.get(key).toString();
                    paramsMap.put(key, value);
                }
            }
            Map<String, List<ContractRecordScan>> resultMap = contractRecordScanService.findAllScansByParams(paramsMap).getReturnContent();
            // 将请求参数放在model里。
            for (String key : paramsMap.keySet()) {
                model.addAttribute(key, paramsMap.get(key));
            }

            List<ContractRecordScan> scanList = null;
            if (resultMap.containsKey("scanList")) {
                scanList = resultMap.get("scanList");
            } else {
                scanList = new ArrayList<ContractRecordScan>();
            }
            List<Long> scanIds = new ArrayList<Long>();
            for (ContractRecordScan scan : scanList) {
                scanIds.add(scan.getId());
            }
            model.addAttribute("scanIds", scanIds);
            model.addAttribute("scanList", scanList);
            if (resultMap.containsKey("oldScanList")) {
                List<ContractRecordScan> oldScanList = resultMap.get("oldScanList");
                model.addAttribute("oldScanList", oldScanList);
            }
        } catch (Exception e) {
            LOGGER.error("Error occurred while finding contract scan list.", e);
            model.addAttribute("errorMsg", "系统内部异常");
        }
        model.addAttribute("auditType", auditType);
        return "/o2o/subCompany/contractScanForm";
    }

    /**
     * 跳转到维护子公司合同备案签署信息页面
     * 
     * @return
     * @throws BusinessException
     */
    @RequestMapping(value = "/contracts")
    public String findContractList(Model model, ContractRecord contract, Integer page, String type, String auditType,
            String timeSort, HttpServletRequest req) throws BusinessException {
        LOGGER.info("start findContractList");
        model.addAttribute("contract", contract);
        model.addAttribute("auditType", auditType);
        model.addAttribute("type", type);
        model.addAttribute("timeSort", timeSort);
        model.addAttribute("timeSortList", SuppContract.CONTRACT_TIME_SORT.values());
        model.addAttribute("contractSubjectTypes", CONTRACTSUBJECTYPE.values());
        model.addAttribute("contractTypes", CONTRACTTYPE.values());
        try {
            Map<String, Object> params = new HashMap<String, Object>();
            params.put("subCompanyId", contract.getSubCompanyId());
            params.put("contractSubjectType", contract.getContractSubjectType());
            params.put("contractType", contract.getContractType());
            params.put("type", type);
            params.put("cancelFlag", Constants.VALID_STATUS);
            params.put("timeSort", timeSort);
            int pagenum = page == null ? 1 : page;

            // 排序
            if (SuppContract.CONTRACT_TIME_SORT.LARGETSMALL.getCode().equals(timeSort)) {
                params.put("_orderby", "contract.END_TIME");
                params.put("_order", "desc");
            } else if (SuppContract.CONTRACT_TIME_SORT.SMALLTOLARGE.getCode().equals(timeSort)) {
                params.put("_orderby", "contract.END_TIME");
                params.put("_order", "asc");
            } else {
                params.put("_orderby", "contract.ID");
                params.put("_order", "desc");
            }

            List<ContractRecord> list = contractRecordService.findAllByParams(params, type).getReturnContent();
            if (null != list && list.size() > 0) {
                Page<ContractRecord> pageParam = Page.page(list.size(), 10, pagenum);
                pageParam.buildUrl(req);
                int start = NumberUtils.toInt(String.valueOf(pageParam.getStartRows()));
                int end = NumberUtils.toInt(String.valueOf(pageParam.getEndRows()));
                list.subList(start, end);
                List<ContractRecord> result = new ArrayList<ContractRecord>();
                result.addAll(list);
                for (ContractRecord c : result) {
                    if (null != c.getEndTime()) {
                        c.setLeftDays(CalendarUtils.getDayCounts(new Date(), c.getEndTime()));
                    }
                    if (CONTRACTSUBJECTYPE.SHOLD.name().equalsIgnoreCase(c.getContractSubjectType())) {
                        List<ShareholderInfo> selectedSholds = contractRecordService.findAllSelectedShareholders(c
                                .getPartnerShareholderIds()).getReturnContent();
                        List<String> tempList = new ArrayList<String>();
                        for (ShareholderInfo s : selectedSholds) {
                            tempList.add(s.getName());
                        }
                        c.setSignerName(StringUtils.join(tempList, ","));

                    } else if (CONTRACTSUBJECTYPE.SUB_CO.name().equalsIgnoreCase(c.getContractSubjectType())) {
                        Map<String, SubCompany> subCompanyMap = subCompanyService.findBySubCompanyId(
                                c.getSubCompanyId(), type).getReturnContent();
                        SubCompany subCompany = subCompanyMap.get("subCompany");
                        c.setSignerName(subCompany.getName());
                    }
                }
                pageParam.setItems(result);
                model.addAttribute("pageParam", pageParam);
            }
        } catch (Exception e) {
            LOGGER.error("Error occurred while show contract records.", e);
            model.addAttribute("errorMsg", "系统内部异常");
        }
        return "/o2o/subCompany/showContracts";
    }

    /**
     * 保存子公司合同备案签署信息
     * 
     * @param model
     * @param subCompanyId
     * @param sholdIds
     * @param relationType
     * @param req
     * @param res
     * @return
     */
    @RequestMapping(value = "/contract", method = RequestMethod.POST)
    @ResponseBody
    public Object saveContract(Model model, ContractRecord contract, HttpServletRequest req, HttpServletResponse res) {
        Map<String, Object> attributes = new HashMap<String, Object>();
        try {
            // 设置创建人
            contract.setCreateUser(this.getLoginUserId());
            Long contractId = contractRecordService.saveContract(contract).getReturnContent();
            attributes.put("contractId", contractId);
        } catch (Exception e) {
            LOGGER.error("Error occurred while saving Contract", e);
            return new ResultMessage(ResultMessage.ERROR, "系统内部异常");
        }
        return new ResultMessage(attributes, ResultMessage.SUCCESS, "保存成功");
    }

    /**
     * 显示新增子公司合同备案签署页面
     * 
     * @param model
     * @param subCompanyId
     * @param req
     * @param res
     * @return
     */
    @RequestMapping(value = "/showContractForm")
    public Object showContractForm(Model model, Long subCompanyId, Long id, String type, String auditType) {
        LOGGER.info("start showContractForm");
        model.addAttribute("subCompanyId", subCompanyId);
        model.addAttribute("auditType", auditType);
        model.addAttribute("type", type);
        model.addAttribute("contractSubjectTypes", CONTRACTSUBJECTYPE.values());
        model.addAttribute("contractTypes", CONTRACTTYPE.values());
        try {
            // 获取当前显示状态的所有父级合作股东信息
            List<ShareholderInfo> parentShareholders = subCompanySholdRelationService.findAllShareholders(subCompanyId,
                    Constants.VALID_STATUS, auditType).getReturnContent();
            // 获取当前显示状态的所有父级合作股东信息
            List<ShareholderInfo> shareholders = subCompanySholdRelationService.findAllShareholders(subCompanyId,
                    Constants.INVALID_STATUS, auditType).getReturnContent();
            model.addAttribute("shareholders", shareholders);
            model.addAttribute("parentShareholders", parentShareholders);

            if (null != id && !id.equals(0l)) {
                Map<String, ContractRecord> contractMap = contractRecordService.getContractById(id, type).getReturnContent();
                if (null == contractMap) {
                    throw new BusinessException("Error occurred while getting ContractRecord with id:" + id);
                }
                model.addAttribute("contract", contractMap.get("contract"));
                model.addAttribute("oldContract", contractMap.get("oldContract"));
                ContractRecord contract = contractMap.get("contract");
                if (null != contract && StringUtils.isNotEmpty(contract.getPartnerShareholderIds())) {
                    model.addAttribute("selectedSholdIds",
                            Arrays.asList(StringUtils.split(contract.getPartnerShareholderIds(), ",")));
                }

                ContractRecord oldContract = contractMap.get("oldContract");
                if (null != oldContract
                        && !CONTRACTSUBJECTYPE.SUB_CO.name().equalsIgnoreCase(oldContract.getContractSubjectType())) {
                    List<ShareholderInfo> oldSelectedSholds = contractRecordService
                            .findAllSelectedShareholders(oldContract.getPartnerShareholderIds()).getReturnContent();
                    model.addAttribute("oldSelectedSholds", oldSelectedSholds);
                }
            }
        } catch (Exception e) {
            LOGGER.error(e.getMessage(), e);
            model.addAttribute("errorMsg", "系统内部异常");
        }
        return "/o2o/subCompany/contractInfoForm";
    }

    /**
     * 修改子公司合同备案签署页面
     * 
     * @param model
     * @param shareholderInfo
     * @param locations
     * @param req
     * @param res
     * @return
     */
    @RequestMapping(value = "/contract/edit", method = RequestMethod.POST)
    @ResponseBody
    public Object updateContract(Model model, ContractRecord contract, HttpServletRequest req, HttpServletResponse res) {
        Map<String, Object> attributes = new HashMap<String, Object>();
        try {
            // 设置创建人
            contract.setUpdateUser(this.getLoginUserId());
            Long contractId = contractRecordService.updateContractRecord(contract).getReturnContent();
            attributes.put("contractId", contractId);
        } catch (Exception e) {
            LOGGER.error("Error occurred while updating Contract", e);
            return new ResultMessage(ResultMessage.ERROR, "系统内部异常");
        }
        return new ResultMessage(attributes, ResultMessage.SUCCESS, "保存成功");
    }

    /**
     * 删除子公司合同备案签署页面
     * 
     * @param model
     * @param subCompanyId
     * @param sholdIds
     * @param relationType
     * @param req
     * @param res
     * @return
     */
    @RequestMapping(value = "/contract/remove", method = RequestMethod.POST)
    @ResponseBody
    public Object removeContract(Model model, ContractRecord contract, HttpServletRequest req, HttpServletResponse res) {
        Map<String, Object> attributes = new HashMap<String, Object>();
        try {
            // 设置操作人
            contract.setUpdateUser(this.getLoginUserId());
            Long contractId = contractRecordService.updateContractForRemove(contract).getReturnContent();
            attributes.put("contractId", contractId);
        } catch (Exception e) {
            LOGGER.error("Error occurred while deleting Contract", e);
            return new ResultMessage(ResultMessage.ERROR, "系统内部异常");
        }
        return new ResultMessage(attributes, ResultMessage.SUCCESS, "保存成功");
    }

    private void uploadFile(MultipartFile file, String serverType, ContractRecordScan object) throws IOException,
            Exception {
        LOGGER.debug("start upload file.");
        String fileName = file.getOriginalFilename();
        if (file.getSize() > 18874368L) {
            throw new IllegalArgumentException("文件不可以大于18M");
        }
        Long pid = vstFSClient.uploadFile(fileName, file.getBytes(), serverType);
        if (pid == 0) {
            throw new IllegalArgumentException("上传文件失败");
        }
        object.setFileId(pid);
        object.setName(fileName);
    }
}
