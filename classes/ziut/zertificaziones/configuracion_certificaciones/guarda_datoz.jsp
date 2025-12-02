<%@ page language="java" 
                contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"
                import="java.sql.*,java.lang.*,java.util.*, comun.*, certificacion_ciut.*" errorPage="../../error.jsp" 
                import="org.json.simple.JSONObject"
%>
<%
if (session.getAttribute("usuario") == null)
{
	out.print("FAVOR DE INICIAR SESION NUEVAMENTE");
}
else
{
int cuenta_correctos=0;
try
{		
		CIUT_certificacion ce=new CIUT_certificacion();
		
		ce.cve_certificacion=Integer.parseInt(request.getParameter("p_cve_certificacion"));
		ce.nombre_certificacion=request.getParameter("p_nombre_certificacion");
		ce.fecha_ins_inicio=request.getParameter("p_fecha_ins_inicio");	
		ce.fecha_ins_fin=request.getParameter("p_fecha_ins_fin");	
		ce.fecha_entrega_ficha=request.getParameter("p_fecha_entrega_ficha");	
		ce.fecha_examen=request.getParameter("p_fecha_examen");							
		ce.cve_pago= Integer.parseInt(request.getParameter("p_cve_pago"));		
		ce.cve_persona= Integer.parseInt(request.getParameter("p_cve_persona"));		
										
		ce.guardar_certificacion();			
		 
		if(ce.success_check!=1)
		{
			ce.cve_certificacion=0;
		}
		
		JSONObject json = new JSONObject();
		json.put("cve_certificacion", ce.cve_certificacion);
		out.print(json); 
 		out.flush(); 
}
catch (Exception exc)
{
	out.println("Revisa tu error--> "+exc);
}
}
%>
