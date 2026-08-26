import SwiftUI

struct ConfirmationActionButton: View {
    let title: String
    let role: ConfirmationActionRole
    var compact = false
    let action: () -> Void

    @ObservedObject private var settings = AppSettings.shared

    var body: some View {
        Button {
            if let soundFeedbackEvent = role.soundFeedbackEvent {
                AppSoundFeedback.play(soundFeedbackEvent)
            }
            action()
        } label: {
            HStack(spacing: compact ? 4 : 6) {
                Image(systemName: role.systemImage)
                    .font(.system(size: compact ? 9 : 11, weight: .bold, design: symbolDesign))

                Text(title)
                    .font(.system(size: compact ? 10 : 12, weight: .semibold, design: textDesign))
            }
            .lineLimit(1)
            .padding(.horizontal, compact ? 8 : 12)
            .frame(minHeight: compact ? 26 : 36)
        }
        .buttonStyle(
            ConfirmationActionButtonStyle(
                palette: ConfirmationActionPalette(role: role),
                isPixelTheme: settings.experienceThemeID == .pixel,
                compact: compact
            )
        )
        .accessibilityLabel(title)
        .accessibilityHint(accessibilityHint)
    }

    private var symbolDesign: Font.Design {
        settings.experienceThemeID == .pixel ? .monospaced : .default
    }

    private var textDesign: Font.Design {
        settings.experienceThemeID == .pixel ? .monospaced : .rounded
    }

    private var accessibilityHint: String {
        switch role {
        case .approve:
            return "允许这一次操作"
        case .scopedApproval:
            return "在当前会话中持续允许这类操作"
        case .deny:
            return "拒绝这次操作"
        case .neutral:
            return "在原应用中继续处理"
        }
    }
}

struct ExperienceThemeOptionCard: View {
    let theme: ExperienceThemeID
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .firstTextBaseline, spacing: 8) {
                    Text(theme.title)
                        .font(.system(size: 14, weight: .semibold, design: theme == .pixel ? .monospaced : .rounded))

                    Spacer(minLength: 0)

                    Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                        .font(.system(size: 15, weight: .semibold))
                }

                ExperienceThemePreview(theme: theme)

                Text(theme.subtitle)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .buttonStyle(
            ExperienceThemeOptionCardStyle(
                theme: theme,
                isSelected: isSelected
            )
        )
        .accessibilityLabel("\(theme.title) 体验主题")
        .accessibilityValue(isSelected ? "已选择" : "未选择")
    }
}

private struct ConfirmationActionPalette {
    let background: Color
    let border: Color

    init(role: ConfirmationActionRole) {
        switch role {
        case .approve:
            background = Color(red: 0.12, green: 0.52, blue: 0.30)
            border = Color(red: 0.39, green: 0.86, blue: 0.56)
        case .scopedApproval:
            background = Color(red: 0.13, green: 0.36, blue: 0.74)
            border = Color(red: 0.43, green: 0.67, blue: 1.00)
        case .deny:
            background = Color(red: 0.67, green: 0.20, blue: 0.24)
            border = Color(red: 1.00, green: 0.49, blue: 0.51)
        case .neutral:
            background = Color.white.opacity(0.12)
            border = Color.white.opacity(0.24)
        }
    }
}

private struct ConfirmationActionButtonStyle: ButtonStyle {
    let palette: ConfirmationActionPalette
    let isPixelTheme: Bool
    let compact: Bool
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(Color.white.opacity(configuration.isPressed ? 0.82 : 1))
            .background {
                RoundedRectangle(
                    cornerRadius: isPixelTheme ? 2 : (compact ? 13 : 18),
                    style: isPixelTheme ? .circular : .continuous
                )
                .fill(palette.background.opacity(configuration.isPressed ? 0.76 : 1))
            }
            .overlay {
                RoundedRectangle(
                    cornerRadius: isPixelTheme ? 2 : (compact ? 13 : 18),
                    style: isPixelTheme ? .circular : .continuous
                )
                .strokeBorder(palette.border.opacity(configuration.isPressed ? 0.55 : 0.82), lineWidth: 1)
            }
            .scaleEffect(configuration.isPressed && !reduceMotion ? 0.98 : 1)
            .animation(reduceMotion ? nil : .easeOut(duration: 0.1), value: configuration.isPressed)
    }
}

private struct ExperienceThemeOptionCardStyle: ButtonStyle {
    let theme: ExperienceThemeID
    let isSelected: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(isSelected ? Color.primary : Color.primary.opacity(0.84))
            .background {
                RoundedRectangle(
                    cornerRadius: theme == .pixel ? 3 : 14,
                    style: theme == .pixel ? .circular : .continuous
                )
                .fill(isSelected ? Color.accentColor.opacity(0.16) : Color.primary.opacity(0.045))
            }
            .overlay {
                RoundedRectangle(
                    cornerRadius: theme == .pixel ? 3 : 14,
                    style: theme == .pixel ? .circular : .continuous
                )
                .strokeBorder(
                    isSelected ? Color.accentColor.opacity(0.8) : Color.primary.opacity(0.10),
                    lineWidth: isSelected ? 1.5 : 1
                )
            }
            .opacity(configuration.isPressed ? 0.78 : 1)
    }
}

private struct ExperienceThemePreview: View {
    let theme: ExperienceThemeID

    var body: some View {
        VStack(spacing: 5) {
            HStack(spacing: 4) {
                Circle().fill(Color.red.opacity(0.86))
                Circle().fill(Color.yellow.opacity(0.86))
                Circle().fill(Color.green.opacity(0.86))
                Spacer()
                RoundedRectangle(cornerRadius: theme == .pixel ? 1 : 3)
                    .fill(Color.white.opacity(0.36))
                    .frame(width: 28, height: 5)
            }
            .frame(height: 9)

            HStack(spacing: 4) {
                theme == .pixel
                    ? Color(red: 0.08, green: 0.12, blue: 0.18)
                    : Color.primary.opacity(0.10)

                VStack(spacing: 4) {
                    HStack(spacing: 3) {
                        Color(red: 0.12, green: 0.52, blue: 0.30)
                        Color(red: 0.13, green: 0.36, blue: 0.74)
                        Color(red: 0.67, green: 0.20, blue: 0.24)
                    }
                    .frame(height: 7)

                    RoundedRectangle(cornerRadius: theme == .pixel ? 1 : 3)
                        .fill(Color.primary.opacity(0.18))
                        .frame(height: 5)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: theme == .pixel ? 1 : 6))
            .frame(height: 28)
        }
        .padding(7)
        .background(previewBackground)
    }

    @ViewBuilder
    private var previewBackground: some View {
        if theme == .pixel {
            RoundedRectangle(cornerRadius: 2)
                .fill(Color(red: 0.04, green: 0.07, blue: 0.10))
                .overlay {
                    Canvas { context, size in
                        let step: CGFloat = 5
                        for x in stride(from: 0, through: size.width, by: step) {
                            context.stroke(
                                Path(CGRect(x: x, y: 0, width: 0.5, height: size.height)),
                                with: .color(.white.opacity(0.07))
                            )
                        }
                        for y in stride(from: 0, through: size.height, by: step) {
                            context.stroke(
                                Path(CGRect(x: 0, y: y, width: size.width, height: 0.5)),
                                with: .color(.white.opacity(0.07))
                            )
                        }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 2))
                }
        } else {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(Color.primary.opacity(0.055))
        }
    }
}
