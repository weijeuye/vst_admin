<html>
   <head>
    <style>
		#typeTable td, #typeTable th, #visitLimit th, #visitLimit td, #fetchLimit th, #fetchLimit td, #passTimeLimit th, #passTimeLimit td {
            border: none;
			padding: 0;
        }
		#typeTable th, #visitLimit th, #fetchLimit th , #passTimeLimit th{
			background-color: #ffffff;
			color: #000000;
            vertical-align: top;
		}
		#typeTable input, #fetchLimit input, #visitLimit input,#passTimeLimit input{
            margin: 0;
		}

        #typeTable div, #visitLimit div, #fetchLimit div, #passTimeLimit div{
            padding-bottom: 5px;
        }

        .stop-scrolling {
            height: 100%;
            overflow: hidden;
        }

        .icon { display: inline-block; width: 14px; height: 14px; background-image: url("http://pic.lvmama.com/img/backstage/v1/common.png"); vertical-align: middle; }

        .icon-warning{background-position: 0 -50px;}

        .pull-left { float: left; }

        .w735{width: 735px;}

		.pb5{padding-bottom: 5px;}

        .w300{width: 300px;}
        .w260{width: 230px;}
        .w30{width: 30px;}
        .w70{width: 70px;}

        .ml35{margin-left: 35px;}

        .w85{width: 85px;}
        .w61{width: 61px;}
        .w38{width: 38px;}
        .w386{width: 386px;}
        .w239{width: 239px;}
        .w398{width: 398px;}
        .w262{width: 262px;}
        .w582{width: 522px;}
        .w305{width: 245px;}

        .mb20{margin-bottom: 20px;}

        .info-tip-warning{color: #999999}

        .vt{vertical-align: top}
        .mr22{margin-right: 22px;}

        /*栅格布局*/
        .row { *zoom: 1; min-height: 1px; }
        .row:after { content: "\0020"; display: block; height: 0; clear: both; overflow: hidden; visibility: hidden; }

        .col { float: left; min-height: 1px; }

        .info-right{margin-right: 7px;}

        .text-right { text-align: right; }
        .info-way{ float: right}




    </style>
   <script type="text/javascript" src="/vst_admin/js/ticket/ticketGoodsDescription.js"></script>
  </head>
  <body>
	<form id="dataForm">
		<table class="p_table form-inline">
			<tbody>
				<input type="hidden" name="suppGoodsId" value=${ticketGoodsFormattedDesc.suppGoodsId}>
				<tr>
					<td class="p_label vt w85 ">
						<p>   <i class="cc1">*</i>费用包含:</p>
                    </td>
					<td colspan=2 id="feeContentTd">
                        <div class="mb10" >
							<#if ticketGoodsFormattedDesc.feeContents??>
								<#assign feeContents = ticketGoodsFormattedDesc.feeContents/>
							</#if>
							<#if feeContents??>
								<#list feeContents.feeContents as fee>
									<#include "/goods/ticket/goods/formattedDesc/feeContent.ftl"/>
								</#list>
							<#else>
								<#assign fee_index = 0/>
								<#include "/goods/ticket/goods/formattedDesc/feeContent.ftl"/>
							</#if>
                        </div>
                        <div class="col">
                            <div class="tip tip-warning info-tip-warning clearfix mb10 w735">
                         <span class="pull-left">
                            <span class="icon icon-warning"></span>
                         </span>
                                <div class="pull-left ml10">
                                    填写什么门票，可包含门票、车票、餐票……         + 数量 + 量词        （填写什么门票，可包含门票、车票、餐票…… + 数量 + ）
                                </div>
                            </div>
                        </div>
                        <div class="info-tip-warning w78 pull-left">
                            前台显示
                        </div>
                        <div class="pull-left" id="feeContentShow">
                        </div>
					</td>
				</tr>
				 <tr>
				   <td class="p_label vt w85 ">
						<p>费用不包含:</p>
                   </td>
                  <td colspan=2><input type="text"   placeholder="请填写费用不包含相关信息" class="form-control w582 mr10" name="costsNotIncluded" value=<#if ticketGoodsFormattedDesc?? && ticketGoodsFormattedDesc.costsNotIncluded??>"${ticketGoodsFormattedDesc.costsNotIncluded}"</#if>></td>
				</tr>
                <tr>
					<#if ticketGoodsFormattedDesc?? && ticketGoodsFormattedDesc.typeDesc??><#assign typeDesc=ticketGoodsFormattedDesc.typeDesc/><#else><#assign NO_TYPE_DESC=true/></#if>
                    <td class="p_label vt" >票种说明
                        <div>
                            <input type="text" class="w38" id="ticketDesc" name="typeDesc.ticketDesc"<#if typeDesc??>value="${typeDesc.ticketDesc}"</#if> placeholder="${typeDesc.ticketDesc!老人票}" data-validate-regular="/^(\+|-)?\d+$/" data-validate="{required:true}">
                        </div>
                    </td>
                    <td colspan=2 style="padding: 0">
						<table id="typeTable">
							<tbody>
								<tr>
									<th>
										<div class="col info-right">
											<label><input type="checkbox" class="" <#if NO_TYPE_DESC>disabled<#elseif typeDesc.ageLimit??>checked<#else><#assign NO_AGE_LIMIT = true/></#if>>年龄限定</label>
										</div>
									</th>
									<td>
									<#if NO_TYPE_DESC || NO_AGE_LIMIT>
										<#assign AGE_FOUND_INDEX = -1/>
									<#else>
										<#if typeDesc.ageLimit.combine == "TO">
											<#assign AGE_FOUND_INDEX=1>
										<#elseif typeDesc.ageLimit.heightAgeVOs[0].upFlag>
											<#assign AGE_FOUND_INDEX=0>
										<#else>
											<#assign AGE_FOUND_INDEX=2>
										</#if>
									</#if>
                                        <div class="col ">
                                            <input type="radio" class="info-right info-radio no_submit"
                                                   name="typeDesc.ageLimitFlag"
												   <#if AGE_FOUND_INDEX == -1>disabled<#elseif AGE_FOUND_INDEX == 0>checked</#if>>
                                            <input type="text" class=" w30"
                                                   data-validate-regular="/^(\+|-)?\d+$/"
                                                   name="typeDesc.ageLimit.heightAgeVOs[0].age"
												   <#if AGE_FOUND_INDEX != 0>disabled<#else>value="${typeDesc.ageLimit.heightAgeVOs[0].age}"</#if>
                                                   data-validate="{required:true}"> 周岁
                                            （
                                            <select <#if AGE_FOUND_INDEX != 0>disabled</#if> name="typeDesc.ageLimit.heightAgeVOs[0].includeFlag" class="w70">
                                                <option <#if AGE_FOUND_INDEX == 0 && typeDesc.ageLimit.heightAgeVOs[0].includeFlag>selected</#if> value="true">含 </option>
                                                <option <#if AGE_FOUND_INDEX == 0 && ! (typeDesc.ageLimit.heightAgeVOs[0].includeFlag)>selected</#if> value="false">不含 </option>
                                            </select>
                                            ）<input type="hidden" <#if AGE_FOUND_INDEX !=0>disabled</#if>
                                                    name="typeDesc.ageLimit.heightAgeVOs[0].upFlag"
                                                    value="true"> 以上（
                                            <input type="text" class="w386"
												   <#if AGE_FOUND_INDEX != 0>disabled<#else>value="${typeDesc.ageLimit.remark}"</#if>
                                                   name="typeDesc.ageLimit.remark"
                                                   placeholder="此处填备注说明。无，可不填。" maxlength="50">
                                            ）
                                        </div>
                                        <div class="col ">
                                            <input type="radio" class="info-right info-radio no_submit"
                                                   name="typeDesc.ageLimitFlag"
												   <#if AGE_FOUND_INDEX == -1>disabled<#elseif AGE_FOUND_INDEX == 1>checked</#if> >
                                            <input type="text" class=" w30"
                                                   data-validate-regular="/^(\+|-)?\d+$/"
                                                   name="typeDesc.ageLimit.heightAgeVOs[0].age"
												   <#if AGE_FOUND_INDEX != 1>disabled<#else>value="${typeDesc.ageLimit.heightAgeVOs[0].age}"</#if>
                                                   data-validate="{required:true}"> 周岁
                                            （
                                            <select <#if AGE_FOUND_INDEX != 1>disabled</#if>
                                                    name="typeDesc.ageLimit.heightAgeVOs[0].includeFlag"
                                                    class="w70 ">
                                                <option
												<#if AGE_FOUND_INDEX == 1 && typeDesc.ageLimit.heightAgeVOs[0].includeFlag>selected</#if>
                                                value="true">含
                                                </option>
                                                <option
												<#if AGE_FOUND_INDEX == 1 && ! (typeDesc.ageLimit.heightAgeVOs[0].includeFlag)>selected</#if>
                                                value="false">不含
                                                </option>
                                            </select>
                                            ）<input type="hidden" <#if AGE_FOUND_INDEX !=1>disabled</#if>
                                                    name="typeDesc.ageLimit.combine"
                                                    value="TO">~<input type="text" class=" w30"
																	   <#if AGE_FOUND_INDEX != 1>disabled<#else>value="${typeDesc.ageLimit.heightAgeVOs[1].age}"</#if>
                                                                       name="typeDesc.ageLimit.heightAgeVOs[1].age">周岁
                                            （
                                            <select class="w70 "
                                                    name="typeDesc.ageLimit.heightAgeVOs[1].includeFlag"
													<#if AGE_FOUND_INDEX != 1>disabled</#if>>
                                                <option
												<#if AGE_FOUND_INDEX == 1 && typeDesc.ageLimit.heightAgeVOs[1].includeFlag>selected</#if>
                                                value="true">含
                                                </option>
                                                <option
												<#if AGE_FOUND_INDEX == 1 && ! (typeDesc.ageLimit.heightAgeVOs[1].includeFlag)>selected</#if>
                                                value="false">不含
                                                </option>
                                            </select>
                                            ）
                                            （
                                            <input type="text" class="w239" placeholder="此处填备注说明。无，可不填。"
                                                   maxlength="50"
                                                   name="typeDesc.ageLimit.remark"
												   <#if AGE_FOUND_INDEX != 1>disabled<#else>value="${typeDesc.ageLimit.remark}"</#if>>
                                            ）
                                        </div>
                                        <div class="col ">
                                            <input type="radio" class="info-right info-radio no_submit"
                                                   name="typeDesc.ageLimitFlag"
												   <#if AGE_FOUND_INDEX == -1>disabled<#elseif AGE_FOUND_INDEX == 2>checked</#if>>
                                            <input type="text" class=" w30"
                                                   data-validate-regular="/^(\+|-)?\d+$/"
                                                   name="typeDesc.ageLimit.heightAgeVOs[0].age"
												   <#if AGE_FOUND_INDEX != 2>disabled<#else>value="${typeDesc.ageLimit.heightAgeVOs[0].age}"</#if>
                                                   data-validate="{required:true}"> 周岁
                                            （
                                            <select class="w70 "
                                                    name="typeDesc.ageLimit.heightAgeVOs[0].includeFlag"
													<#if AGE_FOUND_INDEX != 2>disabled</#if>>
                                                <option <#if AGE_FOUND_INDEX == 2 && typeDesc.ageLimit.heightAgeVOs[0].includeFlag>selected</#if> value="true">含</option>
                                                <option <#if AGE_FOUND_INDEX == 2 && !(typeDesc.ageLimit.heightAgeVOs[0].includeFlag)>selected</#if> value="false">不含</option>
                                            </select>
                                            ）<input type="hidden" <#if AGE_FOUND_INDEX !=2>disabled</#if>
                                                    name="typeDesc.ageLimit.heightAgeVOs[0].upFlag"
                                                    value="false">以下（
                                            <input type="text" class="w386" placeholder="此处填备注说明。无，可不填。"
                                                   maxlength="50"
                                                   name="typeDesc.ageLimit.remark"
												   <#if AGE_FOUND_INDEX != 2>disabled<#else>value="${typeDesc.ageLimit.remark}"</#if>>
                                            ）
                                        </div>
									</td>
								</tr>
								<tr>
									<th>
										<div class="col info-right">
											<label><input type="checkbox" class="" <#if NO_TYPE_DESC>disabled<#elseif typeDesc.heightLimit??>checked<#else><#assign NO_HEIGHT_LIMIT = true/></#if>>身高限定</label>
										</div>
									</th>
									<td>
										<#if NO_TYPE_DESC || NO_HEIGHT_LIMIT>
											<#assign HEIGHT_FOUND_INDEX = -1/>
										<#else>
											<#if typeDesc.heightLimit.combine == "TO">
												<#assign HEIGHT_FOUND_INDEX=1>
											<#elseif typeDesc.heightLimit.heightAgeVOs[0].upFlag>
												<#assign HEIGHT_FOUND_INDEX=0>
											<#else>
												<#assign HEIGHT_FOUND_INDEX=2>
											</#if>
										</#if>
										<div class="col ">
											<input type="radio" class="info-right info-radio no_submit" name="typeDesc.heightLimitFlag" <#if HEIGHT_FOUND_INDEX == -1>disabled<#elseif HEIGHT_FOUND_INDEX == 0>checked</#if>>
											<input type="text" class=" w30" data-validate-regular="/^(\+|-)?\d+$/" data-validate="{required:true}" name="typeDesc.heightLimit.heightAgeVOs[0].height" <#if HEIGHT_FOUND_INDEX != 0>disabled<#else>value="${typeDesc.heightLimit.heightAgeVOs[0].height}"</#if>> 米
											（
												<select class="w70 " name="typeDesc.heightLimit.heightAgeVOs[0].includeFlag" <#if HEIGHT_FOUND_INDEX != 0>disabled</#if>>
													<option <#if HEIGHT_FOUND_INDEX == 0 && typeDesc.heightLimit.heightAgeVOs[0].includeFlag>selected</#if> value="true">含</option>
													<option <#if HEIGHT_FOUND_INDEX == 0 && ! (typeDesc.heightLimit.heightAgeVOs[0].includeFlag)>selected</#if> value="false">不含</option>
												</select>
											）<input type="hidden" <#if HEIGHT_FOUND_INDEX !=0>disabled</#if> name="typeDesc.heightLimit.heightAgeVOs[0].upFlag" value="true">以上（
											<input type="text" class="w398" placeholder="此处填备注说明。无，可不填。" maxlength="50" name="typeDesc.heightLimit.remark" <#if HEIGHT_FOUND_INDEX != 0>disabled<#else>value="${typeDesc.heightLimit.remark}"</#if>>
											）
										</div>
										<div class="col ">
											<input type="radio" class="info-right info-radio no_submit" name="typeDesc.heightLimitFlag" <#if HEIGHT_FOUND_INDEX == -1>disabled<#elseif HEIGHT_FOUND_INDEX == 1>checked</#if>>
											<input type="text" class=" w30" data-validate-regular="/^(\+|-)?\d+$/" data-validate="{required:true}" name="typeDesc.heightLimit.heightAgeVOs[0].height" <#if HEIGHT_FOUND_INDEX != 1>disabled<#else>value="${typeDesc.heightLimit.heightAgeVOs[0].height}"</#if>> 米
											（
												<select class="w70 " name="typeDesc.heightLimit.heightAgeVOs[0].includeFlag" <#if HEIGHT_FOUND_INDEX != 1>disabled</#if>>
													<option <#if HEIGHT_FOUND_INDEX == 1 && typeDesc.heightLimit.heightAgeVOs[0].includeFlag>selected</#if> value="true">含</option>
													<option <#if HEIGHT_FOUND_INDEX == 1 && ! (typeDesc.heightLimit.heightAgeVOs[0].includeFlag)>selected</#if> value="false">不含</option>
												</select>
											）<input type="hidden" <#if HEIGHT_FOUND_INDEX !=1>disabled</#if> name="typeDesc.heightLimit.combine" value="TO">~<input type="text" class=" w30" name="typeDesc.heightLimit.heightAgeVOs[1].height" <#if HEIGHT_FOUND_INDEX != 1>disabled<#else>value="${typeDesc.heightLimit.heightAgeVOs[1].height}"</#if>>米
											（
												<select class="w70 " name="typeDesc.heightLimit.heightAgeVOs[1].includeFlag" <#if HEIGHT_FOUND_INDEX != 1>disabled</#if>>
													<option <#if HEIGHT_FOUND_INDEX == 1 && typeDesc.heightLimit.heightAgeVOs[1].includeFlag>selected</#if> value="true">含</option>
													<option <#if HEIGHT_FOUND_INDEX == 1 && ! (typeDesc.heightLimit.heightAgeVOs[1].includeFlag)>selected</#if> value="false">不含</option>
												</select>
											）
											（
											<input type="text" class="w302" placeholder="此处填备注说明。无，可不填。" maxlength="50" name="typeDesc.heightLimit.remark" <#if HEIGHT_FOUND_INDEX != 1>disabled<#else>value="${typeDesc.heightLimit.remark}"</#if>>
											）
										</div>
										<div class="col ">
											<input type="radio" class="info-right info-radio no_submit" name="typeDesc.heightLimitFlag" <#if HEIGHT_FOUND_INDEX == -1>disabled<#elseif HEIGHT_FOUND_INDEX == 2>checked</#if>>
											<input type="text" class=" w30" data-validate-regular="/^(\+|-)?\d+$/" data-validate="{required:true}" name="typeDesc.heightLimit.heightAgeVOs[0].height" <#if HEIGHT_FOUND_INDEX != 2>disabled<#else>value="${typeDesc.heightLimit.heightAgeVOs[0].height}"</#if> > 米
											（
												<select class="w70 " name="typeDesc.heightLimit.heightAgeVOs[0].includeFlag" <#if HEIGHT_FOUND_INDEX != 2>disabled</#if>>
													<option <#if HEIGHT_FOUND_INDEX == 2 && typeDesc.heightLimit.heightAgeVOs[0].includeFlag>selected</#if> value="true">含</option>
													<option <#if HEIGHT_FOUND_INDEX == 2 && ! (typeDesc.heightLimit.heightAgeVOs[0].includeFlag)>selected</#if> value="false">不含</option>
												</select>
											）<input type="hidden" <#if HEIGHT_FOUND_INDEX !=2>disabled</#if> name="typeDesc.heightLimit.heightAgeVOs[0].upFlag" value="false">以下（
											<input type="text" class="w398" placeholder="此处填备注说明。无，可不填。" maxlength="50" name="typeDesc.heightLimit.remark" <#if HEIGHT_FOUND_INDEX != 2>disabled<#else>value="${typeDesc.heightLimit.remark}"</#if>>
											）
										</div>
									</td>
								</tr>
								<tr>
									<th>
										<div class="col info-right w61">
											<label><input type="checkbox" <#if NO_TYPE_DESC>disabled<#elseif typeDesc.defines?? && typeDesc.defines?size gt 0>checked<#else><#assign NO_TYPE_DEFINES = true/></#if> >自定义</label>
										</div>
									</th>
									<td id="defineTd">
										<#if NO_TYPE_DESC || NO_TYPE_DEFINES>
											<#assign define_index=0/>
											<div class="row">
												<#include "/goods/ticket/goods/formattedDesc/define.ftl"/>
											</div>
										<#else>
											<#list typeDesc.defines as define>
												<div class="row">
													<#include "/goods/ticket/goods/formattedDesc/define.ftl"/>
												</div>
											</#list>
										</#if>
									</td>
								</tr>
								<tr>
									<th>
										<div class="col info-right w61">
											<label>且/或</label>
										</div>
									</th>
									<td>
										<div class="col ">
											<select class="w70" name="typeDesc.combine" <#if NO_TYPE_DESC>disabled</#if> id="ticketDescCombine">
												<option <#if typeDesc?? && typeDesc.combine == "OR">selected</#if> value="OR">或</option>
												<option <#if typeDesc?? && typeDesc.combine == "AND">selected</#if> value="AND">且</option>
											</select>
										</div>
									</td>
								</tr>
								<tr>
									<th>
										<div class="info-tip-warning w78 pull-left">前台显示</div>
									</th>
									<td>
										<div class="col js-col-text info-show-text" id="ticketTypeDescShow">
										</div>
									</td>
								</tr>
							</tbody>
						</table>
                    </td>
                </tr>
				<tr>
					<td class="p_label vt">是否需要取票：</td>
					<td colspan=2>
                        <div class="row">
                            <div class="col w70">
                                <label><input type="radio" name="needFetchTicket" <#if ticketGoodsFormattedDesc.needFetchTicket?? && ticketGoodsFormattedDesc.needFetchTicket == 'Y'>checked</#if> value="Y">是</label>
                            </div>
                            <div class="col w70">
                                <label><input type="radio" name="needFetchTicket" <#if (! ticketGoodsFormattedDesc.needFetchTicket??) || ticketGoodsFormattedDesc.needFetchTicket == 'N'>checked</#if> value="N">否</label>
                            </div>
                        </div>
                    </td>
				</tr>
				 <tr>
					<td class="p_label vt"> <i class="cc1">*</i>入园时间：</td>
					<td colspan=2 style="padding: 0">
						<table>
							<tbody id="visitLimit">
								<tr>
									<th>
										<div class="mb10 w61">
											<input type="radio" name="visitLimit.limitFlag" value="N" <#if (! ticketGoodsFormattedDesc.visitLimit??) || (! ticketGoodsFormattedDesc.visitLimit.limitFlag??) || (ticketGoodsFormattedDesc.visitLimit.limitFlag == 'N')>checked</#if> value="false">无限制</input>
										</div>
									</th>
								</tr>
								<tr>
									<th>
										<div class="mb10 pull-left w61">
											<input type="radio" name="visitLimit.limitFlag" value="Y" <#if ticketGoodsFormattedDesc.visitLimit?? && ticketGoodsFormattedDesc.visitLimit.limitFlag == 'Y'>checked<#assign HAS_VISIT_LIMIT=true/></#if> value="true">有限制</input>
										</div>
									</th>
									<td id="visitLimitTd">
										<#if HAS_VISIT_LIMIT>
											<#list ticketGoodsFormattedDesc.visitLimit.timeLimitVOs as visitTimeLimit>
												<#include "/goods/ticket/goods/formattedDesc/visitTime.ftl"/>
											</#list>
										<#else>
											<#assign visitTimeLimit_index = 0/>
											<#include "/goods/ticket/goods/formattedDesc/visitTime.ftl"/>
										</#if>
									</td>
									<tr>
										<th>
											<div class="info-tip-warning w78 pull-left">
												前台显示
											</div>
										</th>
									<td>
										<div class="col js-col-text info-show-text" id="visitLimitShow">
										</div>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </td>
				</tr>
                <!--取票时间-->
                <tr>
                    <td class="p_label vt">取票时间：</td>
                    <td colspan=2 style="padding: 0">
						<table>
							<tbody id="fetchLimit">
								<tr>
									<th>
                                        <div class="mb10 w61">
                                            <input type="radio" name="fetchLimit.limitFlag" value="N" <#if (! ticketGoodsFormattedDesc.fetchLimit??) || (! ticketGoodsFormattedDesc.fetchLimit.limitFlag??) || (ticketGoodsFormattedDesc.fetchLimit.limitFlag == "N")>checked</#if>>无限制</input>
                                        </div>
									</th>
								</tr>
								<tr>
									<th>
										<div class="mb10 pull-left w61">
											<input type="radio" name="fetchLimit.limitFlag" value="Y" <#if ticketGoodsFormattedDesc.fetchLimit?? && ticketGoodsFormattedDesc.fetchLimit.limitFlag == "Y">checked<#assign HAS_FETCH_LIMIT=true/></#if>>有限制</input>
										</div>
									</th>
									<td id="fetchLimitTd">
                                        <a class="btn btn_cc1 copyVisitLimit <#if (! ticketGoodsFormattedDesc.visitLimit??) || (! ticketGoodsFormattedDesc.visitLimit.limitFlag??) || (ticketGoodsFormattedDesc.visitLimit.limitFlag == 'N') || (! ticketGoodsFormattedDesc.fetchLimit??) || (! ticketGoodsFormattedDesc.fetchLimit.limitFlag??) || (ticketGoodsFormattedDesc.fetchLimit.limitFlag == "N")>disabled</#if>" style="width: 70px;height:18px;">同入园时间</a>
										<#if HAS_FETCH_LIMIT>
											<#list ticketGoodsFormattedDesc.fetchLimit.timeLimitVOs as fetchTimeLimit>
												<#include "/goods/ticket/goods/formattedDesc/fetchTime.ftl"/>
											</#list>
										<#else>
											<#assign fetchTimeLimit_index = 0/>
											<#include "/goods/ticket/goods/formattedDesc/fetchTime.ftl"/>
										</#if>
									</td>
								</tr>
								<tr>
									<th>
										<div class="info-tip-warning w78 pull-left">
											前台显示
										</div>
									</th>
									<td>
										<div class="col js-col-text info-show-text" id="fetchLimitShow">
										</div>
									</td>
								</tr>
                            </tbody>
                        </table>
                    </td>
                </tr>

				<tr>
					<td class="p_label vt"> <i class="cc1">*</i>入园地点：</td>
					<td colspan=2>
						<input class="w300" maxlength="100" type="text" id="visitSite" placeholder="景区地址+景区名称+入园位置" name="visitSite" value="${ticketGoodsFormattedDesc.visitSite}"></td>
				</tr>
                <tr>
                    <td class="p_label vt">取票地点：</td>
                    <td colspan=2>
                    <#if needShowAddMapImg?? >
	                    <table class="p_table form-inline">
						  <tr>
						    <td>
							    <div class="mb10">
		                            <a class="btn btn_cc1 copyVisitSite" style="width: 70px;height:18px;">同入园地点</a>
		                        </div>
						    </td>
						    <td>取票地图上传:</td>
						    <td  rowspan = "2">
						    	<input type="hidden" name="mapImgUrl" value=${ticketGoodsFormattedDesc.mapImgUrl}>
						    	<img id="mapImg" src="${ticketGoodsFormattedDesc.mapImgUrl}" height="90" width="90">
						    </td>
						    <td>
							    <div class="mb10">
		                            <a href="javascript:void(0)" class="btn btn_cc1" onclick="uploadImg()" style="width: 60px;height:15px;">上传图片</a>
		                        </div>
						    </td>
						  </tr>
						  <tr>
						    <td>
						    	<input class="w300" maxlength="100" type="text" id="fetchSite" placeholder="景区地址+景区名称+入园位置" value="${ticketGoodsFormattedDesc.fetchSite}" name="fetchSite">
						    </td>
						    <td></td>
						    <td>
							    <div class="mb10">
		                             <a href="javascript:void(0)" class="btn btn_cc1" onclick="deleteImg()" style="width: 60px;height:15px;">删除图片</a>
		                        </div>
						    </td>
						  </tr>
						</table> 
	                    <#else>
	                		<div class="mb10">
	                            <a class="btn btn_cc1 copyVisitSite" style="width: 70px;height:18px;">同入园地点</a>
	                        </div>
	                        <input class="w300" maxlength="100" type="text" id="fetchSite" placeholder="景区地址+景区名称+入园位置" value="${ticketGoodsFormattedDesc.fetchSite}" name="fetchSite">
					  </#if>
					</td>
                </tr>
                
			   <tr>
					<td class="p_label vt"> <i class="cc1">*</i>入园/取票方式：</td>
					<td id="visitMethodTd">
						<#if ticketGoodsFormattedDesc.visitMethods??>
							<#assign visitMethods = ticketGoodsFormattedDesc.visitMethods/>
						</#if>
                        <div class="row mb10 w735">
                            <div class="col">
                                <input type="checkbox" name="visitMethods['QR_CODE'].on" value="true" <#if visitMethods?? && visitMethods['QR_CODE']?? && visitMethods['QR_CODE'].on>checked</#if>>
								凭驴妈妈订单短信中的<input type="text" name="visitMethods['QR_CODE'].remark" <#if visitMethods?? && visitMethods['QR_CODE']?? && visitMethods['QR_CODE'].on><#else>disabled </#if> value="<#if visitMethods?? && visitMethods['QR_CODE']??>${visitMethods['QR_CODE'].remark}<#else>入园凭证（入园辅助码或二维码）</#if>" class="w188" maxlength="100">入园。
                            </div>
                            <div class="info-way text-right" >
                                【门票专用 | 二维码通关】
                            </div>
                        </div>
                        <div class="row mb10 w735">
                            <div class="col">
                                <input type="checkbox" name="visitMethods['ID_CARD'].on" value="true" <#if visitMethods?? && visitMethods['ID_CARD']?? && visitMethods['ID_CARD'].on>checked</#if>>
                                凭下单时预留的身份证入园。
                            </div>
                            <div class="info-way text-right">
                                【门票专用 | 刷身份证通关】
                            </div>
                        </div>
                        <div class="row mb10 w735">
                            <div class="col">
                                <input type="checkbox" name="visitMethods['EBK'].on" value="true" <#if visitMethods?? && visitMethods['EBK']?? && visitMethods['EBK'].on>checked</#if>>
								凭驴妈妈订单短信中的<input type="text" name="visitMethods['EBK'].remark" <#if visitMethods?? && visitMethods['EBK']?? && visitMethods['EBK'].on><#else>disabled </#if> value="<#if visitMethods?? && visitMethods['EBK']??>${visitMethods['EBK'].remark}<#else>订单号或手机号或姓名或辅助码</#if>" class="w188" maxlength="100">入园。
                            </div>
                            <div class="info-way text-right">
                                【门票专用 | EBK通关】
                            </div>
                        </div>
                        <div class="row mb10 w735">
                            <div class="col">
                                <input type="checkbox" name="visitMethods['NEED_PAPER'].on" value="true" <#if visitMethods?? && visitMethods['NEED_PAPER']?? && visitMethods['NEED_PAPER'].on>checked</#if>> 打印驴妈妈邮件中的电子确认函，携带纸质凭证和护照入园。
                            </div>
                            <div class="info-way text-right">
                                【出境专用】
                            </div>
                        </div>
                        <div class="row mb10 w735">
                            <div class="col">
                                <input type="checkbox" name="visitMethods['NO_NEED_PAPER'].on" value="true" <#if visitMethods?? && visitMethods['NO_NEED_PAPER']?? && visitMethods['NO_NEED_PAPER'].on>checked</#if>>凭驴妈妈邮件中的电子确认函（可不用打印，直接出示即可）和护照入园。
                            </div>
                            <div class="info-way text-right">
                                【出境专用】
                            </div>
                        </div>
                        <div class="row mb10 w735">
                            <div class="col">
                                <input type="checkbox" name="visitMethods['PAPER_AND_FETCH'].on" value="true" <#if visitMethods?? && visitMethods['PAPER_AND_FETCH']?? && visitMethods['PAPER_AND_FETCH'].on>checked</#if>>
                                打印驴妈妈邮件中的电子确认函，携带纸质凭证和护照至<input type="text" <#if visitMethods?? && visitMethods['PAPER_AND_FETCH']?? && visitMethods['PAPER_AND_FETCH'].on><#else>disabled </#if> name="visitMethods['PAPER_AND_FETCH'].remark" class="w82" maxlength="100" value="<#if visitMethods?? && visitMethods['PAPER_AND_FETCH']??>${visitMethods['PAPER_AND_FETCH'].remark}<#else>上车点取票后</#if>">入园。
                            </div>
                            <div class="info-way text-right">
                                【出境专用】
                            </div>
                        </div>
                        <div class="row mb10 w735">
                            <div class="col">
                                                  
                                    <input type="checkbox" name="visitMethods['DEFINE'].on" value="true" <#if visitMethods?? && visitMethods['DEFINE']?? && visitMethods['DEFINE'].on ||suppGoods.goodsSpec=='TEAM'>checked</#if>>
                                    <input type="text" <#if visitMethods?? && visitMethods['DEFINE']?? && visitMethods['DEFINE'].on><#else>disabled </#if> name="visitMethods['DEFINE'].remark" class="w156" maxlength="100" value="<#if visitMethods?? && visitMethods['DEFINE']??>${visitMethods['DEFINE'].remark}<#elseif suppGoods??&&suppGoods.goodsSpec=='TEAM'>打印并携带通知单，由导游带领统一入园<#else>驴妈妈订单号、姓名、人数</#if>">
                                
                               
                            </div>
                            <div class="info-way text-right">
                                【门票出境通用 | 传真、第三方再次发送短信、其他特殊的请自定义】
                            </div>
                        </div>
                        <div class="info-tip-warning w78 pull-left">
                            前台显示
                        </div>
                        <div class="col js-col-text info-show-text" id="visitMethodShow">
                        </div>

					</td>
			   </tr>
			   <!--通关时间限制-->
			   <tr>
                    <td class="p_label vt"> <i class="cc1">*</i>通关时间限制：</td>
                    <td colspan=2 style="padding: 0">
                        <table>
                            <tbody id="passTimeLimit">
                                <tr>
                                    <th>
                                        <div class="mb10 w61">
                                            <input type="radio" name="passTimeLimit.passFlag" value="N" <#if (! ticketGoodsFormattedDesc.passTimeLimit??) || (! ticketGoodsFormattedDesc.passTimeLimit.passFlag??) || (ticketGoodsFormattedDesc.passTimeLimit.passFlag == 'N')>checked</#if> value="false">无限制</input>
                                        </div>
                                    </th>
                                </tr>
                                <tr>
                                    <th>
                                        <div class="mb10 pull-left w61">
                                            <input type="radio" name="passTimeLimit.passFlag" value="Y" <#if ticketGoodsFormattedDesc.passTimeLimit?? && ticketGoodsFormattedDesc.passTimeLimit.passFlag == 'Y'>checked<#assign HAS_PASS_LIMIT=true/></#if> value="true">下单后</input>
                                        </div>
                                    </th>
                                    <td id="passTimeLimitTd">
                                        <#if HAS_PASS_LIMIT>
                                            <div class="pb5">
                                            <input type="text"  maxlength="2" style="width:30px; " name="passTimeLimit.hour" value ="<#if ticketGoodsFormattedDesc.passTimeLimit?? && ticketGoodsFormattedDesc.passTimeLimit.hour != "">${ticketGoodsFormattedDesc.passTimeLimit.hour}<#else></#if>" />:<#t>
                                            <input type="text"  maxlength="2" style="width:30px; " name="passTimeLimit.minute" value="<#if ticketGoodsFormattedDesc.passTimeLimit?? && ticketGoodsFormattedDesc.passTimeLimit.minute != "">${ticketGoodsFormattedDesc.passTimeLimit.minute}<#else></#if>"/>:<#t>
                                            <input type="text"  maxlength="2" style="width:30px; " name="passTimeLimit.seconds" value="<#if ticketGoodsFormattedDesc.passTimeLimit?? && ticketGoodsFormattedDesc.passTimeLimit.seconds != "">${ticketGoodsFormattedDesc.passTimeLimit.seconds}<#else></#if>"/><#t>后可通关
                                            </div>
                                        <#else>
                                           <div class="pb5">
                                            <input type="text"  maxlength="2" style="width:30px; " name="passTimeLimit.hour"  disabled="disabled" value ="" /> : <#t>
                                            <input type="text"  maxlength="2" style="width:30px; " name="passTimeLimit.minute" disabled="disabled" value=""/> : <#t>
                                            <input type="text"  maxlength="2" style="width:30px; " name="passTimeLimit.seconds" disabled="disabled" value=""/> <#t>后可通关
                                            </div>
                                        </#if>
                                    </td>
                                 </tr>
                            </tbody>
                        </table>
                    </td>
                </tr>
			   <tr>
					<td class="p_label vt">重要提示：</td>
                    <td colspan=2>
                        <textarea  maxlength="1000" style="width:735px; height:80px;" name="others">
                        <#if suppGoods??&&suppGoods.goodsSpec=='TEAM'&&(!ticketGoodsFormattedDesc.others??||ticketGoodsFormattedDesc.others=='')>
1.请如实填写导游信息，因导游信息不能正常取票的，后果自负
2.仅限出游日当天出游
3.如您实际到达的人数有减少，如实告知景区验证的工作人员，并带回回执单等信息，我司核实后予以退款，如不符合则不予以退款。
                        <#else>
                             ${ticketGoodsFormattedDesc.others}
                        </#if>
                       </textarea>
                    </td>
				</tr>

                <tr>
                    <td class="p_label">有效期：</td>
                    <td colspan=2>
					<#if suppGoodsExp?? && suppGoods??>
						<#if suppGoodsExp.useInsTruction??>
						    (${suppGoodsExp.useInsTruction})
						</#if>					
						<#if suppGoods.aperiodicFlag=='Y'>
                            &nbsp;${suppGoodsExpInfo} <#if suppGoodsExp.unvalidDesc??>期票商品不适用日期：${suppGoodsExp.unvalidDesc}</#if>
						<#else>
                            指定游玩日${suppGoodsExp.days}天内有效
						</#if>
					</#if>

                    </td>
                </tr>
                <tr>
                    <td class="p_label">退改说明：</td>
                    <td colspan=2>
					${cancelStrategyDesc}
                    </td>
                </tr>


			</tbody>
		</table>
	</form>
<div class="p_box box_info clearfix mb20">
            <div class="fl operate" style="margin-top:20px;"><a class="btn btn_cc1" id="saveDesc">保存</a></div>
</div>
</body>
</html>
	<script>

        var VISIT_NEW_LINE = ['<div> <select class="w70 " name="visitLimit.timeLimitVOs[',
		'].startHour"><#list hourList as item><option value="${item}">${item}</option></#list></select> : <select class="w70 " name="visitLimit.timeLimitVOs[',
		'].startMinute"><#list minuteList as item><option value="${item}">${item}</option></#list></select> ~ <select class="w70 " name="visitLimit.timeLimitVOs[',
        '].endHour"><#list hourList as item><option value="${item}">${item}</option></#list></select> : <select class="w70 " name="visitLimit.timeLimitVOs[',
		'].endMinute"><#list minuteList as item><option value="${item}">${item}</option></#list></select></select> &emsp;&emsp;(<input type="text" placeholder="此处填备注说明。无，可不填。" maxlength="50" name="visitLimit.timeLimitVOs[',
		'].remark">) <a class="visit_add addBtn btn" style="cursor: pointer" data="',
		'">增加</a><a class="visit_delete deleteBtn btn" style="cursor: pointer" data="',
		'">删除</a></div>'];

        var FETCH_NEW_LINE = ['<div> <select class="w70 " name="fetchLimit.timeLimitVOs[',
            '].startHour"><#list hourList as item><option value="${item}">${item}</option></#list></select> : <select class="w70 " name="fetchLimit.timeLimitVOs[',
            '].startMinute"><#list minuteList as item><option value="${item}">${item}</option></#list></select> ~ <select class="w70 " name="fetchLimit.timeLimitVOs[',
            '].endHour"><#list hourList as item><option value="${item}">${item}</option></#list></select> : <select class="w70 " name="fetchLimit.timeLimitVOs[',
            '].endMinute"><#list minuteList as item><option value="${item}">${item}</option></#list></select></select> &emsp;&emsp;(<input type="text" placeholder="此处填备注说明。无，可不填。" maxlength="50" name="fetchLimit.timeLimitVOs[',
            '].remark">) <a class="fetch_add addBtn btn" style="cursor: pointer" data="',
            '">增加</a><a class="fetch_delete deleteBtn btn" style="cursor: pointer" data="',
            '">删除</a></div>'];

		$(function(){
		isView();

			$(".textWidth[maxlength]").each(function(){
				var	maxlen = $(this).attr("maxlength");
				if(maxlen != null && maxlen != ''){
					var l = maxlen*12;
					if(l >= 500) {
						l = 500;
					} else if (l <= 200){
						l = 200;
					} else {
						l = 400;
					}
					$(this).width(l);
				}
				$(this).keyup(function() {
					vst_util.countLenth($(this));
				});
			});		
			
			if($("#wx").attr("checked")=='checked'){
			  $("#minute").attr("disabled","true");
			  $("#hour").attr("disabled","true");
			}
			 $("#wx").click(function(){
			 	 $("#minute").attr("disabled","true");
			  	 $("#hour").attr("disabled","true");
			 })
			 
			 $("#yx").click(function(){
			     $("#minute").removeAttr("disabled");
			  	 $("#hour").removeAttr("disabled");
			 })
			 $("input[name='passTimeLimit.passFlag']").click(function(){
                var passLimitVal= $("input[name='passTimeLimit.passFlag']:checked").val();
                if(passLimitVal=="Y"){
                    $("#passTimeLimitTd").find("input").attr("disabled",false);
                }else{
                     $("#passTimeLimitTd").find("input").each(function(){
                        $(this).val("");
                      });
                    $("#passTimeLimitTd").find("input").attr("disabled",true);
                }
             })
		})
		function validatePassTime(){
		var passLimitVal= $("input[name='passTimeLimit.passFlag']:checked").val();
          if(passLimitVal=="Y"){
            var passTime="";
            $("#passTimeLimitTd").find("input").each(function(){
                        passTime=passTime+$(this).val()+":";
            });
            if(passTime!=""){
              passTime=passTime.substring(0,passTime.length-1);
            }
            var re = /^([01][0-9]|2[0-3])\:[0-5][0-9]\:[0-5][0-9]$/;
            if(!re.test(passTime)){
                 return false;
            }else{
             return true;
            }
          }else{
             return true;
          }
		}
		
		//上传地图图片
		function uploadImg(){
			var mapImgUrl = $("input[name=mapImgUrl]").val();
			if(null != mapImgUrl && "" != mapImgUrl){
				alert("请保证一个商品只绑定一个图片");
				return;
			}
			var url = "/pic/photo/photo/imgPlugIn.do";
    		url += "?relationId=${ticketGoodsFormattedDesc.suppGoodsId!''}&relationType=1";
    		if("${imgLimitType!'' }" != '') {
    			url += "&imgLimitType=${imgLimitType!''}"
    		}
    		//设置图片尺寸表示为1
    		photoRatio = 1;
    		comPhotoAddDialog = new xDialog(url,{},{title:"上传图片",iframe:true,width:920,height:750});
		}
		
		//删除地图图片
		function deleteImg(){
		 if(confirm("确定删除取票地图上传？")){
			$("#mapImg").attr("src",null);
	        $("input[name=mapImgUrl]").val(null);
		 }
		}
		
		var isCommitted=false;
		$("#saveDesc").bind('click',function(){
			if(!$("#.dialog #dataForm").validate({
				rules : {
					priceIncludes : {
					}					
				},
				messages : {
					featureDesc : '不可输入特殊字符'
				}
			}).form()){
				$(this).removeAttr("disabled");
				return false;
			}
			if (! validateSubmitTicketDesc()) {
				return false;
			}
			//通关时间格式校验
			if(!validatePassTime()){
			    alert("通关限制时间格式错误,正确格式如：08:00:00");
			    return false;
			}
			var msg = '确认保存吗 ？';	
			if(refreshSensitiveWord($("#dataForm").find("input[type='text'],textarea"))){
			 	msg = '内容含有敏感词,是否继续?'
			}			
			
			if(!isCommitted){
				$.confirm(msg,function(){
					//避免重复提交
				    isCommitted=true;
					$.ajax({
						url : "/vst_admin/ticket/goods/goods/suppGoodsFormattedDescAdd.do",
						type : "post",
						data : $(".dialog #dataForm").find('[class!=no_submit]').serialize(),
						success : function(result) {
							if (result.message !== undefined) {
	                            alert(result.message);
							} else {
								alert(JSON.parse(result).message);
							}
							isCommitted=false;
						}
					});
				});
			}else{
			    $.alert("不能重复提交表单");
			    return false;
			}
			
		refreshSensitiveWord($("#dataForm").find("input[type='text'],textarea"));
		});
		
		function photoCallback(photoJson, extJson) {
	        var imgUrl = "";
	        if (photoJson.photos) {
	            imgUrl = "http://pic.lvmama.com" + photoJson.photos[0].photoUpdateUrl;
	        }
	        if (photoJson.photo) {
	            imgUrl = "http://pic.lvmama.com" + photoJson.photo.photoUpdateUrl;
	        }
	        $("#mapImg").attr("src",imgUrl);
	        $("input[name=mapImgUrl]").val(imgUrl);
	        comPhotoAddDialog.close();
	    }
		
	</script>