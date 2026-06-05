/*
 * Gaelium Dark Style - Modern Theme
 * Based on Qt-Frameless-Window-DarkStyle by Juergen Skrotzky
 * Modified for Gaelium Project 2026
 */

#include <QDebug>
#include "darkstyle.h"

DarkStyle::DarkStyle():
  DarkStyle(styleBase())
{ }

DarkStyle::DarkStyle(QStyle *style):
  QProxyStyle(style)
{ }

QStyle *DarkStyle::styleBase(QStyle *style) const {
  static QStyle *base = !style ? QStyleFactory::create(QStringLiteral("Fusion")) : style;
  return base;
}

QStyle *DarkStyle::baseStyle() const
{
  return styleBase();
}

void DarkStyle::polish(QPalette &palette)
{
  // Gaelium Modern Dark Theme
  palette.setColor(QPalette::Window, QColor(10, 15, 26));           // #0a0f1a
  palette.setColor(QPalette::WindowText, QColor(232, 236, 244));    // #e8ecf4
  palette.setColor(QPalette::Disabled, QPalette::WindowText, QColor(90, 100, 120));
  palette.setColor(QPalette::Base, QColor(17, 24, 39));             // #111827
  palette.setColor(QPalette::AlternateBase, QColor(26, 34, 54));    // #1a2236
  palette.setColor(QPalette::ToolTipBase, QColor(26, 34, 54));
  palette.setColor(QPalette::ToolTipText, QColor(232, 236, 244));
  palette.setColor(QPalette::Text, QColor(232, 236, 244));          // #e8ecf4
  palette.setColor(QPalette::Disabled, QPalette::Text, QColor(90, 100, 120));
  palette.setColor(QPalette::Dark, QColor(5, 8, 16));               // #050810
  palette.setColor(QPalette::Shadow, QColor(0, 0, 0));
  palette.setColor(QPalette::Button, QColor(17, 24, 39));           // #111827
  palette.setColor(QPalette::ButtonText, QColor(232, 236, 244));
  palette.setColor(QPalette::Disabled, QPalette::ButtonText, QColor(90, 100, 120));
  palette.setColor(QPalette::BrightText, QColor(13, 181, 132));     // #0db584 green accent
  palette.setColor(QPalette::Link, QColor(13, 181, 132));           // #0db584
  palette.setColor(QPalette::Highlight, QColor(8, 138, 99));        // #088a63
  palette.setColor(QPalette::Disabled, QPalette::Highlight, QColor(26, 34, 54));
  palette.setColor(QPalette::HighlightedText, QColor(255, 255, 255));
  palette.setColor(QPalette::Disabled, QPalette::HighlightedText, QColor(90, 100, 120));
}

void DarkStyle::polish(QApplication *app)
{
  if (!app) return;

  // loadstylesheet
  QFile qfDarkstyle(QStringLiteral(":/darkstyle/qss"));
  if (qfDarkstyle.open(QIODevice::ReadOnly | QIODevice::Text))
  {
    // set stylesheet
    QString qsStylesheet = QString::fromLatin1(qfDarkstyle.readAll());
    app->setStyleSheet(qsStylesheet);
    qfDarkstyle.close();
  }
}
