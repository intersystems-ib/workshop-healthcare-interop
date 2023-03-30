Class App.Installer
{

XData CreateNamespaceManifest [ XMLNamespace = INSTALLER ]
{
<Manifest> 
    <Log Text="Creating namespace ${Namespace}" Level="0"/> 
    <Namespace Name="${Namespace}" Create="yes" Ensemble=""> 
        <Configuration> 
            <Database Name="${Namespace}-DATA" Dir="${DataDBPath}" Create="yes" MountRequired="true" Resource="%DB_${Namespace}" PublicPermissions="RW" MountAtStartup="true"/> 
            <Database Name="${Namespace}-APP" Dir="${CodeDBPath}" Create="yes" MountRequired="true" Resource="%DB_${Namespace}" PublicPermissions="RW" MountAtStartup="true"/> 
        </Configuration>
    </Namespace>
</Manifest>
}

ClassMethod RunCreateNamespace(ByRef pVars, pLogLevel As %Integer = 0, pInstaller As %Installer.Installer) As %Status [ CodeMode = objectgenerator, Internal ]
{
    Quit ##class(%Installer.Manifest).%Generate(%compiledclass, %code, "CreateNamespaceManifest")
}

/// Create namespace. You can use this method to prepare your environment before installation.
/// 
/// set vars("Namespace")="TEST" 
/// set vars("DataDBPath")="/opt/dpipe/db/DATA" 
/// set vars("CodeDBPath")="/opt/dpipe/db/CODE"
/// do ##class(DataPipe.Installer).CreateNamespace(.vars)
ClassMethod CreateNamespace(ByRef vars) As %Status
{
    set ret = $$$OK
    try {
        $$$ThrowOnError(..RunCreateNamespace(.vars))
    } catch ex {
        set ret = ex.AsStatus()
    }
    quit ret
}

}
