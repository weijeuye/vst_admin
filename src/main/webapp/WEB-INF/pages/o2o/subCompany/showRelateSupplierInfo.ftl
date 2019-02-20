<!DOCTYPE html>
<html>
<head>
<#include "/base/head_meta.ftl"/>
</head>
<body style="height: 425px;">
	<div class="iframe-content">
		<input type="hidden" name="supplierId" value="${supplier.supplierId}" />
		<table class="p_table form-inline">
			<tbody>
				<tr>
					<td class="p_label">供应商名称：</td>
					<td>${supplier.supplierName}</td>
					<td class="p_label">供应商类型：</td>
					<td><#list supplierTypeList as supplierType><#if supplier.supplierType == supplierType.code>${supplierType.cnName!''}</#if></#list></td>
				</tr>
				<tr>
					<td class="p_label">所在地区：</td>
					<td><#if supplier.supplierDistrict??>${supplier.supplierDistrict!''}</#if></td>
					<td class="e_label">地址：</td>
					<td>${supplier.address}</td>
				</tr>
				<tr>
					<td class="p_label">电话：</td>
					<td>${supplier.tel}</td>
					<td class="p_label">传真：</td>
					<td>${supplier.fax}</td>
				</tr>
				<tr>
					<td class="p_label">网址：</td>
					<td>${supplier.site}</td>
					<td class="p_label">邮编：</td>
					<td>${supplier.zip}</td>
				</tr>
				<tr>
					<td class="p_label">父供应商：</td>
					<td colspan="3"><#if supplier.fatherSupplier??>${supplier.fatherSupplier!''}</#if></td>
				</tr>
			</tbody>
		</table>

		<!-- 联系人列表 -->
		<div class="p_box">
			<table class="p_table table_center">
				<thead>
					<tr>
						<th>姓名</th>
						<th>电话</th>
						<th>手机</th>
						<th>性别</th>
						<th>职务</th>
						<th>说明</th>
						<th>email</th>
					</tr>
				</thead>
				<tbody>
					<#list pageParam.items as contact>
					<tr>
						<td>${contact.name!''}</td>
						<td>${contact.tel!''}</td>
						<td>${contact.mobile!''}</td>
						<td><#if contact.sex == "MAN">先生<#elseif contact.sex=="WOMAN">女士 <#else></#if></td>
						<td>${contact.job!''}</td>
						<td>${contact.personDesc!''}</td>
						<td>${contact.email!''}</td>
					</tr>
					</#list>
				</tbody>
			</table>
			<#if pageParam.items?exists && pageParam.totalResultSize gt 0>
			<div class="paging">${pageParam.getPagination()}</div>
			</#if>
		</div>
	</div>
	<#include "/base/foot.ftl"/>
</body>
</html>