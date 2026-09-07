param(
    [string]$OutputDirectory = (Join-Path $PSScriptRoot '..\..\assets\images\pinterest')
)

# Editable, code-native typography and line art for Small Space Signal.
# Raster exports are drawn at twice their delivery resolution and downsampled.
Add-Type -AssemblyName System.Drawing
$ErrorActionPreference = 'Stop'
$null = New-Item -ItemType Directory -Force -Path $OutputDirectory
$script:Green = [System.Drawing.ColorTranslator]::FromHtml('#315b4f')
$script:Cream = [System.Drawing.ColorTranslator]::FromHtml('#f8f6f0')
$script:MutedGreen = [System.Drawing.ColorTranslator]::FromHtml('#809087')
$script:LightGreen = [System.Drawing.ColorTranslator]::FromHtml('#e5e9df')
$script:Charcoal = [System.Drawing.ColorTranslator]::FromHtml('#303b35')
$script:Sand = [System.Drawing.ColorTranslator]::FromHtml('#e8dfcf')

function New-Canvas([int]$Width, [int]$Height, [System.Drawing.Color]$Background) {
    $bitmap = [System.Drawing.Bitmap]::new($Width * 2, $Height * 2)
    $bitmap.SetResolution(144, 144)
    $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
    $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $graphics.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit
    $graphics.CompositingQuality = [System.Drawing.Drawing2D.CompositingQuality]::HighQuality
    $graphics.Clear($Background)
    $graphics.ScaleTransform(2, 2)
    return @{ Bitmap = $bitmap; Graphics = $graphics; Width = $Width; Height = $Height }
}

function Save-Canvas($Canvas, [string]$FileName) {
    $result = [System.Drawing.Bitmap]::new($Canvas.Width, $Canvas.Height)
    $result.SetResolution(96, 96)
    $render = [System.Drawing.Graphics]::FromImage($result)
    $render.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $render.CompositingQuality = [System.Drawing.Drawing2D.CompositingQuality]::HighQuality
    $render.DrawImage($Canvas.Bitmap, 0, 0, $Canvas.Width, $Canvas.Height)
    $result.Save((Join-Path $OutputDirectory $FileName), [System.Drawing.Imaging.ImageFormat]::Png)
    $render.Dispose()
    $result.Dispose()
    $Canvas.Graphics.Dispose()
    $Canvas.Bitmap.Dispose()
}

function New-Pen([System.Drawing.Color]$Color, [single]$Width = 2) {
    $pen = [System.Drawing.Pen]::new($Color, $Width)
    $pen.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
    $pen.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
    $pen.LineJoin = [System.Drawing.Drawing2D.LineJoin]::Round
    return $pen
}

function Draw-Text($Graphics, [string]$Text, [string]$Family, [single]$Size,
    [single]$X, [single]$Y, [System.Drawing.Color]$Color,
    [System.Drawing.FontStyle]$Style = [System.Drawing.FontStyle]::Regular) {
    $font = [System.Drawing.Font]::new($Family, $Size, $Style, [System.Drawing.GraphicsUnit]::Pixel)
    $brush = [System.Drawing.SolidBrush]::new($Color)
    $Graphics.DrawString($Text, $font, $brush, $X, $Y, [System.Drawing.StringFormat]::GenericTypographic)
    $font.Dispose()
    $brush.Dispose()
}

function Draw-TrackedText($Graphics, [string]$Text, [single]$Size, [single]$X,
    [single]$Y, [single]$Tracking, [System.Drawing.Color]$Color) {
    $font = [System.Drawing.Font]::new('Segoe UI', $Size, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Pixel)
    $brush = [System.Drawing.SolidBrush]::new($Color)
    $format = [System.Drawing.StringFormat]::GenericTypographic.Clone()
    $format.FormatFlags = $format.FormatFlags -bor [System.Drawing.StringFormatFlags]::MeasureTrailingSpaces
    foreach ($character in $Text.ToCharArray()) {
        $glyph = [string]$character
        $Graphics.DrawString($glyph, $font, $brush, $X, $Y, $format)
        $X += $Graphics.MeasureString($glyph, $font, 1000, $format).Width + $Tracking
    }
    $format.Dispose()
    $font.Dispose()
    $brush.Dispose()
}

# Avatar: the monogram and corner marks remain within the central 70%.
$avatar = New-Canvas 600 600 $Green
$g = $avatar.Graphics
$rim = New-Pen ([System.Drawing.Color]::FromArgb(65, $Cream)) 1.4
$g.DrawEllipse($rim, 48, 48, 504, 504)
$corners = New-Pen ([System.Drawing.Color]::FromArgb(135, $Cream)) 2
$g.DrawLines($corners, [System.Drawing.PointF[]]@(
    [System.Drawing.PointF]::new(157, 205),
    [System.Drawing.PointF]::new(157, 157),
    [System.Drawing.PointF]::new(205, 157)))
$g.DrawLines($corners, [System.Drawing.PointF[]]@(
    [System.Drawing.PointF]::new(395, 443),
    [System.Drawing.PointF]::new(443, 443),
    [System.Drawing.PointF]::new(443, 395)))
$monogram = [System.Drawing.Drawing2D.GraphicsPath]::new()
$serif = [System.Drawing.FontFamily]::new('Georgia')
$monogram.AddString('SS', $serif, 0, 224, [System.Drawing.PointF]::new(0, 0), [System.Drawing.StringFormat]::GenericTypographic)
$bounds = $monogram.GetBounds()
$translation = [System.Drawing.Drawing2D.Matrix]::new()
$translation.Translate(300 - $bounds.X - $bounds.Width / 2, 295 - $bounds.Y - $bounds.Height / 2)
$monogram.Transform($translation)
$creamBrush = [System.Drawing.SolidBrush]::new($Cream)
$g.FillPath($creamBrush, $monogram)
$monogram.Dispose()
$translation.Dispose()
$serif.Dispose()
$creamBrush.Dispose()
$rim.Dispose()
$corners.Dispose()
Save-Canvas $avatar 'profile-avatar.png'

# Cover: restrained editorial typography with original geometric interior art.
$cover = New-Canvas 1600 900 $Cream
$g = $cover.Graphics
$borderPen = New-Pen ([System.Drawing.Color]::FromArgb(45, $Green)) 1
$g.DrawRectangle($borderPen, 44, 44, 1512, 812)
$accent = [System.Drawing.SolidBrush]::new($Green)
$g.FillRectangle($accent, 119, 251, 62, 4)
Draw-TrackedText $g 'SMALL SPACE. MORE POSSIBILITY.' 17 118 204 2.3 $Green
Draw-Text $g 'Small Space Signal' 'Georgia' 76 112 319 $Green
Draw-Text $g 'Practical ideas for compact homes.' 'Segoe UI' 29 118 433 $Charcoal
$categoryLine = 'STORAGE  {0}  ORGANIZATION  {0}  RENTER-FRIENDLY LIVING' -f [char]0x00B7
Draw-TrackedText $g $categoryLine 15 119 520 1.1 $Green

# A soft architectural shape grounds the line art without overpowering the name.
$arch = [System.Drawing.Drawing2D.GraphicsPath]::new()
$arch.StartFigure()
$arch.AddLine(1040, 680, 1040, 337)
$arch.AddArc(1040, 190, 430, 294, 180, 180)
$arch.AddLine(1470, 337, 1470, 680)
$arch.CloseFigure()
$paleBrush = [System.Drawing.SolidBrush]::new($LightGreen)
$g.FillPath($paleBrush, $arch)
$artPen = New-Pen $Green 3
$lightPen = New-Pen ([System.Drawing.Color]::FromArgb(160, $Green)) 2
$sandBrush = [System.Drawing.SolidBrush]::new($Sand)
$roomPen = New-Pen ([System.Drawing.Color]::FromArgb(70, $Green)) 1.6
$g.DrawLine($roomPen, 1010, 704, 1490, 704)

# Floating shelf with books and a simple bowl.
$g.DrawLine($artPen, 1083, 386, 1404, 386)
$g.DrawLine($lightPen, 1115, 386, 1115, 406)
$g.DrawLine($lightPen, 1373, 386, 1373, 406)
$g.FillRectangle($sandBrush, 1110, 304, 24, 80)
$g.DrawRectangle($lightPen, 1110, 304, 24, 80)
$g.DrawRectangle($lightPen, 1137, 290, 27, 94)
$g.DrawRectangle($lightPen, 1167, 319, 20, 65)
$g.DrawLine($lightPen, 1195, 300, 1227, 380)
$g.DrawLine($lightPen, 1214, 293, 1246, 373)
$g.DrawLine($lightPen, 1195, 300, 1214, 293)
$g.DrawLine($lightPen, 1227, 380, 1246, 373)
$g.DrawArc($lightPen, 1300, 336, 76, 45, 0, 180)
$g.DrawLine($lightPen, 1300, 358, 1376, 358)

# Low cabinet and tactile storage baskets.
$g.DrawRectangle($artPen, 1065, 510, 267, 154)
$g.DrawLine($artPen, 1057, 505, 1340, 505)
$g.DrawLine($lightPen, 1198, 514, 1198, 660)
$g.DrawLine($lightPen, 1079, 666, 1079, 703)
$g.DrawLine($lightPen, 1319, 666, 1319, 703)
$g.FillRectangle($sandBrush, 1082, 540, 97, 99)
$g.DrawRectangle($lightPen, 1082, 540, 97, 99)
$g.DrawRectangle($lightPen, 1216, 540, 97, 99)
$g.DrawLine($lightPen, 1115, 556, 1146, 556)
$g.DrawLine($lightPen, 1248, 556, 1279, 556)
foreach ($lineY in @(582, 597, 612, 627)) {
    $g.DrawLine($roomPen, 1087, $lineY, 1174, $lineY)
    $g.DrawLine($roomPen, 1221, $lineY, 1308, $lineY)
}

# A tabletop lamp and a compact potted plant, purely illustrative.
$lamp = [System.Drawing.PointF[]]@(
    [System.Drawing.PointF]::new(1090, 468), [System.Drawing.PointF]::new(1110, 426),
    [System.Drawing.PointF]::new(1157, 426), [System.Drawing.PointF]::new(1177, 468))
$g.FillPolygon($sandBrush, $lamp)
$g.DrawPolygon($lightPen, $lamp)
$g.DrawLine($lightPen, 1133, 469, 1133, 504)
$g.DrawLine($lightPen, 1113, 503, 1153, 503)
$g.DrawLine($lightPen, 1399, 617, 1401, 427)
$g.DrawBezier($lightPen, 1400, 559, 1367, 544, 1361, 500, 1339, 486)
$g.DrawBezier($lightPen, 1400, 521, 1430, 506, 1444, 471, 1460, 453)
$g.DrawBezier($lightPen, 1400, 477, 1382, 459, 1370, 422, 1352, 412)
$leafBrush = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(210, $Green))
$g.FillEllipse($leafBrush, 1335, 460, 31, 64)
$g.FillEllipse($leafBrush, 1436, 427, 31, 63)
$g.FillEllipse($leafBrush, 1342, 393, 30, 60)
$g.FillEllipse($leafBrush, 1385, 403, 30, 59)
$pot = [System.Drawing.PointF[]]@(
    [System.Drawing.PointF]::new(1358, 613), [System.Drawing.PointF]::new(1441, 613),
    [System.Drawing.PointF]::new(1429, 702), [System.Drawing.PointF]::new(1370, 702))
$g.FillPolygon($sandBrush, $pot)
$g.DrawPolygon($lightPen, $pot)
$g.DrawLine($lightPen, 1360, 628, 1439, 628)

$borderPen.Dispose()
$accent.Dispose()
$arch.Dispose()
$paleBrush.Dispose()
$artPen.Dispose()
$lightPen.Dispose()
$sandBrush.Dispose()
$roomPen.Dispose()
$leafBrush.Dispose()
Save-Canvas $cover 'profile-cover.png'
Write-Output (Join-Path $OutputDirectory 'profile-avatar.png')
Write-Output (Join-Path $OutputDirectory 'profile-cover.png')
